# Конфигурация Neovim для C / C++ / Rust / ASM

![Neovim](https://img.shields.io/badge/Neovim-0.12+-green.svg)
![Platform](https://img.shields.io/badge/Platform-Linux-blue.svg)
![License](https://img.shields.io/badge/License-MIT-yellow.svg)

Модульная конфигурация Neovim для системного программирования: анализ кода, автодополнение,
форматирование, сборка и отладка для четырёх языков. Комментарии и подсказки — на русском.

## Возможности

| | C / C++ | Rust | ASM (NASM x86-64) |
|---|---|---|---|
| Анализ кода, переходы, ошибки | clangd + clang-tidy | rust-analyzer + clippy | asm-lsp |
| Форматирование при сохранении | clang-format | rustfmt | nasmfmt |
| Сборка и запуск (`Space r`) | gcc / g++ / make | cargo / rustc | nasm + ld / gcc |
| Отладчик | codelldb | codelldb | gdb |

А также:
- **Автодополнение** — blink.cmp со сниппетами и подсказкой сигнатур
- **Подсветка** — tree-sitter
- **Поиск** — Telescope (файлы, текст по проекту, символы, диагностика)
- **Дерево файлов** — neo-tree
- **Git** — gitsigns (изменения на полях, blame, откат)
- **Подсказки клавиш** — which-key: нажмите `Space` и подождите
- **Шпаргалка** — `Space ?`
- **Русский `:Tutor`** — интерактивный учебник Vim на русском

## Установка

```bash
git clone https://github.com/kranks-uga/configNvim.git
cd configNvim
./install.sh          # или ./install.sh -y — без вопросов
```

Скрипт:
- проверит зависимости и сделает бэкап существующего `~/.config/nvim`;
- скопирует конфиг и настройку asm-lsp (`~/.config/asm-lsp/.asm-lsp.toml`);
- **без sudo** поставит rust-analyzer (rustup), tree-sitter CLI (cargo), nasmfmt (go);
- поставит плагины (версии из `lazy-lock.json`), парсеры tree-sitter и LSP-серверы через Mason;
- в конце подскажет, какие системные пакеты стоит доустановить.

Можно и без скрипта — склонировать прямо в `~/.config/nvim` и запустить `./install.sh` оттуда.

### Требования

| Обязательно | Для отдельных языков |
|---|---|
| Neovim **0.12+**, git, curl, tar, unzip, gcc, make | g++, nasm, gdb, rustup, go, ripgrep, fzf |

Шрифт с иконками: любой [Nerd Font](https://www.nerdfonts.com/) (например, FiraCode Nerd Font).

```bash
sudo pacman -S neovim git gcc make unzip nasm gdb rustup go ripgrep fzf tree-sitter-cli
```

## Основные клавиши

Leader — **Space** (пробел). Полный список: `Space ?` внутри nvim.

### Файлы и поиск
| Клавиша | Действие |
|---|---|
| `Space Space` / `Space ff` | Найти файл |
| `Space fg` | Поиск текста по проекту |
| `Space fr` | Недавние файлы |
| `Space n` | Дерево файлов |
| `Shift-h` / `Shift-l` | Предыдущий / следующий буфер |
| `Space x` | Закрыть буфер |
| `Ctrl-\` | Плавающий терминал |

### Код
| Клавиша | Действие |
|---|---|
| `gd` | Перейти к определению |
| `grr` | Где используется |
| `K` | Документация (в ASM — описание инструкции) |
| `grn` | Переименовать |
| `gra` | Quick fix / действия |
| `Space e` | Текст ошибки под курсором |
| `]d` / `[d` | Следующая / предыдущая ошибка |
| `Space tt` | Все ошибки проекта |
| `Space co` | Переключить `.h` ↔ `.cpp` |
| `Space cf` | Отформатировать |
| `Space cF` | Вкл/выкл автоформат при сохранении |

### Сборка и отладка
| Клавиша | Действие |
|---|---|
| `Space r` | Собрать и запустить текущий файл |
| `Space b` | Только собрать |
| `Space db` | Точка останова |
| `F5` | Старт / продолжить отладку |
| `F10` / `F11` / `F12` | Шаг через / внутрь / наружу |
| `Space de` | Значение выражения |

**Как собирается файл (`Space r`):**
- **C** — `gcc -std=c17 -g -O0 -Wall -Wextra`, **C++** — `g++ -std=c++23 ...`. Если выше по дереву есть `Makefile` — `make` и `make run`.
- **Rust** — `cargo run`, если есть `Cargo.toml`, иначе `rustc -g`.
- **NASM** — `nasm -f elf64 -g -F dwarf`, затем `ld` (точка входа `_start`) или `gcc -no-pie`, если в файле есть `main`.
- **GAS** (`.s`, `.S`) — `gcc -g -no-pie`.

Бинарник кладётся рядом с исходником, с отладочной информацией, — после `Space b` сразу можно `F5`.

## Структура

```
init.lua                 точка входа
lua/config/
  options.lua            настройки редактора, диагностика, типы файлов
  keymaps.lua            общие клавиши
  autocmds.lua           автокоманды (отступы для ASM и т.п.)
  runner.lua             сборка и запуск текущего файла
  lazy.lua               загрузка lazy.nvim
lua/plugins/
  ui.lua                 тема, статус-строка, which-key, neo-tree, терминал, trouble
  editor.lua             telescope, tree-sitter, gitsigns, autopairs, surround
  lsp.lua                Mason, LSP-серверы, автодополнение, форматирование
  dap.lua                отладчик
.clang-format            стиль C/C++ по умолчанию (LLVM, отступ 4)
extras/asm-lsp.toml      конфиг asm-lsp (NASM, x86-64)
tutor/ru/                русский :Tutor
CHEATSHEET.md            шпаргалка (Space ?)
```

## Настройка под себя

- **Стиль C/C++** — `.clang-format` в конфиге. Если в проекте есть свой `.clang-format`, используется он.
- **Ассемблер GAS вместо NASM** — положите в корень проекта `.asm-lsp.toml` с `assembler = "gas"`.
- **Проекты на CMake** — clangd нужен `compile_commands.json`:
  `cmake -B build -DCMAKE_EXPORT_COMPILE_COMMANDS=ON && ln -s build/compile_commands.json .`

## Если что-то не работает

```vim
:checkhealth           " общая диагностика
:checkhealth vim.lsp   " LSP-серверы
:Mason                 " установленные серверы
:MasonToolsInstall     " доустановить недостающие
:Lazy                  " плагины
:TSUpdate              " парсеры tree-sitter
```

## Лицензия

MIT. Русский перевод `:Tutor` (`tutor/ru/`) взят из дистрибутива Vim и распространяется на условиях лицензии Vim.
