#!/bin/bash

# =============================================
# Скрипт автоматической установки Neovim конфигурации
# =============================================

set -e  # Остановить при ошибке

# Цвета для вывода
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # Без цвета

# Функция для красивого вывода
print_step() {
    echo -e "${BLUE}==>${NC} $1"
}

print_success() {
    echo -e "${GREEN}✓${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}⚠${NC} $1"
}

print_error() {
    echo -e "${RED}✗${NC} $1"
}

echo -e "${GREEN}"
echo "╔════════════════════════════════════════╗"
echo "║  Установка Neovim конфигурации для C++ ║"
echo "╔════════════════════════════════════════╝"
echo -e "${NC}"

# =============================================
# 1. Проверка требований
# =============================================
print_step "Проверка установленных зависимостей..."

# Проверка Neovim
if ! command -v nvim &> /dev/null; then
    print_error "Neovim не установлен!"
    echo "Установите Neovim:"
    echo "  Arch Linux: sudo pacman -S neovim"
    echo "  Ubuntu/Debian: sudo apt install neovim"
    exit 1
fi

NVIM_VERSION=$(nvim --version | head -n1 | awk '{print $2}')
NVIM_MAJOR=$(echo $NVIM_VERSION | cut -d. -f2)

if [ "$NVIM_MAJOR" -lt 8 ]; then
    print_error "Neovim версии $NVIM_VERSION слишком старый!"
    print_error "Требуется Neovim 0.8 или новее"
    exit 1
fi

print_success "Neovim установлен (версия $NVIM_VERSION)"

if [ "$NVIM_MAJOR" -ge 11 ]; then
    print_success "Используется современный Neovim 0.11+ с новым API"
fi

# Проверка Git
if ! command -v git &> /dev/null; then
    print_error "Git не установлен!"
    echo "Установите Git: sudo pacman -S git"
    exit 1
fi
print_success "Git установлен"

# Проверка clangd (опционально)
if ! command -v clangd &> /dev/null; then
    print_warning "clangd не установлен (нужен для C++ LSP)"
    read -p "Установить clangd сейчас? (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        if command -v pacman &> /dev/null; then
            sudo pacman -S clang
        elif command -v apt &> /dev/null; then
            sudo apt install clangd
        else
            print_warning "Установите clangd вручную для вашей системы"
        fi
    fi
else
    print_success "clangd установлен"
fi

# =============================================
# 2. Бэкап существующей конфигурации
# =============================================
NVIM_CONFIG="$HOME/.config/nvim"
BACKUP_DIR="$HOME/.config/nvim.backup.$(date +%Y%m%d_%H%M%S)"

if [ -d "$NVIM_CONFIG" ]; then
    print_warning "Найдена существующая конфигурация Neovim"
    read -p "Создать бэкап и продолжить? (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        print_step "Создание бэкапа в $BACKUP_DIR"
        mv "$NVIM_CONFIG" "$BACKUP_DIR"
        print_success "Бэкап создан: $BACKUP_DIR"
    else
        print_error "Установка отменена"
        exit 1
    fi
fi

# =============================================
# 3. Копирование конфигурации
# =============================================
print_step "Копирование конфигурации в ~/.config/nvim..."

# Создаем директорию
mkdir -p "$NVIM_CONFIG"

# Копируем файлы из текущей директории
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cp "$SCRIPT_DIR/init.lua" "$NVIM_CONFIG/"

# Копируем дополнительные файлы если есть
[ -f "$SCRIPT_DIR/coc-settings.json" ] && cp "$SCRIPT_DIR/coc-settings.json" "$NVIM_CONFIG/"
[ -f "$SCRIPT_DIR/CLAUDE.md" ] && cp "$SCRIPT_DIR/CLAUDE.md" "$NVIM_CONFIG/"
[ -f "$SCRIPT_DIR/QUICKSTART.md" ] && cp "$SCRIPT_DIR/QUICKSTART.md" "$NVIM_CONFIG/"

print_success "Файлы скопированы"

# =============================================
# 4. Установка плагинов
# =============================================
print_step "Установка плагинов через Lazy.nvim..."
echo "Это может занять несколько минут..."

nvim --headless "+Lazy! sync" +qa

if [ $? -eq 0 ]; then
    print_success "Плагины установлены"
else
    print_error "Ошибка при установке плагинов"
    exit 1
fi

# =============================================
# 5. Проверка установки
# =============================================
print_step "Проверка установки..."

if [ -f "$NVIM_CONFIG/init.lua" ]; then
    print_success "init.lua на месте"
else
    print_error "init.lua не найден!"
    exit 1
fi

# =============================================
# Готово!
# =============================================
echo
echo -e "${GREEN}╔════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║     Установка завершена успешно! 🎉    ║${NC}"
echo -e "${GREEN}╚════════════════════════════════════════╝${NC}"
echo
echo "Запустите Neovim командой: nvim"
echo
echo "Полезные команды:"
echo "  :Lazy          - Управление плагинами"
echo "  :Mason         - Управление LSP серверами"
echo "  :checkhealth   - Проверка здоровья Neovim"
echo
echo "Горячие клавиши:"
echo "  ,e             - Открыть дерево файлов"
echo "  ,ff            - Поиск файлов"
echo "  ,fg            - Поиск по тексту"
echo "  F5             - Компилировать и запустить C++ (в .cpp файле)"
echo "  gd             - Перейти к определению"
echo "  K              - Показать документацию"
echo
echo "📚 Документация:"
echo "  - QUICKSTART.md  - Быстрый старт для новичков"
echo "  - CLAUDE.md      - Полная документация"
echo "  - README.md      - Описание проекта"
echo
