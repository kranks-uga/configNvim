#!/usr/bin/env bash
# =============================================
#  Установка конфигурации Neovim для C / C++ / Rust / ASM
#  Использование: ./install.sh        (с вопросами)
#                 ./install.sh -y     (без вопросов)
# =============================================
set -euo pipefail

RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'; BLUE='\033[0;34m'; NC='\033[0m'
step() { echo -e "\n${BLUE}==>${NC} $1"; }
ok()   { echo -e "${GREEN}✓${NC} $1"; }
warn() { echo -e "${YELLOW}⚠${NC} $1"; }
err()  { echo -e "${RED}✗${NC} $1"; }
has()  { command -v "$1" &>/dev/null; }

YES=0
[[ "${1:-}" == "-y" ]] && YES=1
ask() { # ask "вопрос" -> 0 если да
    [[ $YES == 1 ]] && return 0
    read -r -p "$1 (y/n) " -n 1 REPLY; echo
    [[ $REPLY =~ ^[YyДд]$ ]]
}

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
NVIM_CONFIG="${XDG_CONFIG_HOME:-$HOME/.config}/nvim"
MISSING_PKGS=()

echo -e "${GREEN}"
echo "╔══════════════════════════════════════════════╗"
echo "║  Neovim: C · C++ · Rust · ASM — установка    ║"
echo "╚══════════════════════════════════════════════╝"
echo -e "${NC}"

# ---------------------------------------------
# 1. Обязательные зависимости
# ---------------------------------------------
step "Проверка обязательных зависимостей"

if ! has nvim; then
    err "Neovim не установлен: sudo pacman -S neovim"
    exit 1
fi
NVIM_VERSION=$(nvim --version | head -n1 | sed 's/^NVIM v//')
NVIM_MINOR=$(echo "$NVIM_VERSION" | cut -d. -f2)
NVIM_MAJOR=$(echo "$NVIM_VERSION" | cut -d. -f1)
if [[ $NVIM_MAJOR -eq 0 && $NVIM_MINOR -lt 12 ]]; then
    err "Нужен Neovim 0.12+, установлен $NVIM_VERSION"
    exit 1
fi
ok "Neovim $NVIM_VERSION"

FATAL=0
for bin in git curl tar unzip gcc make; do
    if has $bin; then ok "$bin"; else err "$bin не найден"; FATAL=1; fi
done
if [[ $FATAL == 1 ]]; then
    echo "Установите недостающее: sudo pacman -S git curl tar unzip gcc make"
    exit 1
fi

# ---------------------------------------------
# 2. Необязательные (нужны для отдельных языков / функций)
# ---------------------------------------------
step "Проверка инструментов для языков"
check_opt() { # check_opt бинарник пакет-pacman "зачем"
    if has "$1"; then ok "$1"; else warn "$1 не найден — $3"; MISSING_PKGS+=("$2"); fi
}
check_opt g++    gcc      "компиляция C++"
check_opt gdb    gdb      "отладка ASM"
check_opt nasm   nasm     "сборка NASM"
check_opt rg     ripgrep  "поиск текста по проекту (Space fg)"
check_opt fzf    fzf      "быстрый нечёткий поиск"
check_opt cargo  rustup   "Rust (и установка tree-sitter CLI)"
check_opt go     go       "установка nasmfmt (форматирование ASM)"

# ---------------------------------------------
# 3. Копирование конфигурации
# ---------------------------------------------
step "Копирование конфигурации в $NVIM_CONFIG"

if [[ "$(realpath "$SCRIPT_DIR")" == "$(realpath -m "$NVIM_CONFIG")" ]]; then
    ok "Репозиторий уже склонирован в $NVIM_CONFIG — копировать не нужно"
else
    if [[ -e "$NVIM_CONFIG" ]]; then
        BACKUP="$NVIM_CONFIG.backup.$(date +%Y%m%d_%H%M%S)"
        warn "Найдена существующая конфигурация"
        if ask "Переместить её в $BACKUP и продолжить?"; then
            mv "$NVIM_CONFIG" "$BACKUP"
            ok "Бэкап: $BACKUP"
        else
            err "Установка отменена"; exit 1
        fi
    fi
    mkdir -p "$NVIM_CONFIG"
    cp -r "$SCRIPT_DIR"/{init.lua,lua,tutor,CHEATSHEET.md,.clang-format,lazy-lock.json} "$NVIM_CONFIG/"
    ok "Файлы скопированы"
fi

# Конфиг asm-lsp: NASM x86-64
ASM_CFG="${XDG_CONFIG_HOME:-$HOME/.config}/asm-lsp/.asm-lsp.toml"
if [[ -f "$ASM_CFG" ]] && ! cmp -s "$ASM_CFG" "$SCRIPT_DIR/extras/asm-lsp.toml"; then
    warn "$ASM_CFG уже существует — не трогаю"
else
    mkdir -p "$(dirname "$ASM_CFG")"
    cp "$SCRIPT_DIR/extras/asm-lsp.toml" "$ASM_CFG"
    ok "Конфиг asm-lsp: $ASM_CFG"
fi

# ---------------------------------------------
# 4. Инструменты, которые ставятся без sudo
# ---------------------------------------------
step "Установка инструментов (без sudo)"

if has rustup; then
    rustup component add rust-analyzer rustfmt clippy >/dev/null 2>&1 \
        && ok "rust-analyzer, rustfmt, clippy (rustup)" \
        || warn "rustup не смог поставить rust-analyzer"
fi

if has tree-sitter; then
    ok "tree-sitter CLI"
elif has cargo; then
    echo "   Сборка tree-sitter CLI (пара минут)..."
    cargo install --locked tree-sitter-cli >/dev/null 2>&1 && ok "tree-sitter CLI (cargo)" \
        || { warn "Не удалось собрать tree-sitter CLI"; MISSING_PKGS+=("tree-sitter-cli"); }
else
    warn "tree-sitter CLI нужен для подсветки синтаксиса"
    MISSING_PKGS+=("tree-sitter-cli")
fi

if has nasmfmt || [[ -x "$HOME/go/bin/nasmfmt" ]]; then
    ok "nasmfmt"
elif has go; then
    go install github.com/yamnikov-oleg/nasmfmt@latest >/dev/null 2>&1 && ok "nasmfmt (go)" \
        || warn "Не удалось поставить nasmfmt"
fi

# ---------------------------------------------
# 5. Плагины, парсеры, LSP-серверы
# ---------------------------------------------
step "Установка плагинов (lazy.nvim, версии из lazy-lock.json)"
nvim --headless "+Lazy! restore" +qa >/dev/null 2>&1 && ok "Плагины" || { err "Ошибка установки плагинов"; exit 1; }

step "Установка парсеров tree-sitter"
nvim --headless \
    -c "lua require('nvim-treesitter').install({'c','cpp','rust','asm','nasm','lua','vim','vimdoc','query','bash','make','cmake','toml','json','yaml','markdown','markdown_inline'}):wait(600000)" \
    -c qa >/dev/null 2>&1 && ok "Парсеры" || warn "Часть парсеров не установилась — повторите :TSUpdate"

step "Установка LSP-серверов через Mason (clangd, clang-format, asm-lsp, codelldb, lua_ls)"
for attempt in 1 2; do
    nvim --headless -c "Lazy load mason-tool-installer.nvim" -c "MasonToolsInstallSync" -c qa >/dev/null 2>&1 || true
    MASON_BIN="$(nvim --headless -c 'lua io.stdout:write(vim.fn.stdpath("data"))' -c qa 2>/dev/null)/mason/bin"
    MISSING_TOOLS=()
    for t in clangd clang-format asm-lsp codelldb lua-language-server; do
        [[ -e "$MASON_BIN/$t" ]] || MISSING_TOOLS+=("$t")
    done
    [[ ${#MISSING_TOOLS[@]} -eq 0 ]] && break
done
if [[ ${#MISSING_TOOLS[@]} -eq 0 ]]; then
    ok "Все LSP-серверы и отладчик установлены"
else
    warn "Не установились: ${MISSING_TOOLS[*]} — откройте nvim и выполните :MasonToolsInstall"
fi

# ---------------------------------------------
# Итог
# ---------------------------------------------
echo
echo -e "${GREEN}╔══════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║           Установка завершена 🎉              ║${NC}"
echo -e "${GREEN}╚══════════════════════════════════════════════╝${NC}"
if [[ ${#MISSING_PKGS[@]} -gt 0 ]]; then
    echo
    warn "Для полной функциональности доустановите:"
    echo "   sudo pacman -S ${MISSING_PKGS[*]}"
fi
echo
echo "Запуск:       nvim"
echo "Шпаргалка:    Space ?   (внутри nvim)"
echo "Учебник:      :Tutor"
echo "Подробнее:    QUICKSTART.md, README.md"
