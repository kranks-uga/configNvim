# 🚀 Профессиональная конфигурация Neovim для C++

![Neovim](https://img.shields.io/badge/Neovim-0.11+-green.svg)
![Platform](https://img.shields.io/badge/Platform-Linux-blue.svg)
![License](https://img.shields.io/badge/License-MIT-yellow.svg)

Современная, полнофункциональная конфигурация Neovim с VS Code-подобным опытом разработки.

## ✨ Возможности

### 🎨 Современный UI
- **Tokyonight Storm** тема с синими акцентами
- **Bufferline** для вкладок
- **Lualine** statusline с Git и LSP интеграцией
- **Indent guides** для визуализации вложенности
- Подсветка hex цветов в реальном времени

### 💡 Умная разработка
- **Full LSP support** для C++ через clangd
- **Автодополнение** с иконками и приоритетами
- **Snippets** (готовая библиотека для C++)
- **Treesitter** подсветка синтаксиса
- **Auto-pairs** для скобок
- **TODO подсветка** (TODO, FIXME, NOTE, etc)

### 🔍 Навигация
- **Telescope** fuzzy finder (файлы, grep, буферы)
- **NvimTree** файловый менеджер
- **LSP навигация** (go to definition, references, etc)
- **Git signs** в gutter
- **Which-key** подсказки для горячих клавиш

### 🎯 C++ Workflow
- **F5** - компиляция и запуск (релиз)
- **F6** - только компиляция
- **F7** - debug сборка и запуск
- Умные LSP подсказки и автодополнение
- Форматирование кода через clangd

## 🛠 Установка

### Требования
- **Neovim 0.11+** (обязательно!)
- **Git**
- **clangd** (для C++ LSP)
- **make** (для telescope-fzf-native)
- **g++** или **clang** (для компиляции C++)

### Автоматическая установка (рекомендуется)

```bash
git clone https://github.com/kranks-uga/configNvim.git
cd configNvim
./install.sh
```

Скрипт автоматически:
- ✅ Проверит все зависимости
- ✅ Создаст бэкап существующей конфигурации
- ✅ Установит все плагины
- ✅ Предложит установить clangd

### Ручная установка

```bash
# Клонировать репозиторий
git clone https://github.com/kranks-uga/configNvim.git ~/.config/nvim

# Установить плагины
nvim --headless "+Lazy! sync" +qa

# Установить clangd (Arch Linux)
sudo pacman -S clang

# Или Ubuntu/Debian
sudo apt install clangd
```

## ⌨️ Основные горячие клавиши

Leader key: **`,`** (запятая)

### Навигация по файлам
| Клавиша | Действие |
|---------|----------|
| `,e` | Открыть/закрыть файловое дерево |
| `,ff` | Найти файл |
| `,fg` | Поиск по содержимому |
| `,fb` | Список открытых буферов |
| `Tab` / `Shift-Tab` | Следующий/предыдущий буфер |

### LSP (в C++ файлах)
| Клавиша | Действие |
|---------|----------|
| `gd` | Перейти к определению |
| `gr` | Показать все ссылки |
| `K` | Показать документацию |
| `,rn` | Переименовать символ |
| `,ca` | Code actions |
| `,f` | Форматировать код |

### C++ компиляция
| Клавиша | Действие |
|---------|----------|
| `F5` | Компилировать и запустить |
| `F6` | Только компилировать |
| `F7` | Debug сборка с `-g -DDEBUG` |

### Редактирование
| Клавиша | Действие |
|---------|----------|
| `,w` | Сохранить |
| `gcc` | Закомментировать строку |
| `gc` (visual) | Закомментировать выделение |
| `J` / `K` (visual) | Переместить строки вверх/вниз |

**Полный список** горячих клавиш смотрите в [CLAUDE.md](./CLAUDE.md)

## 📦 Установленные плагины

<details>
<summary>Нажмите для просмотра полного списка (18 плагинов)</summary>

### UI
- tokyonight.nvim
- lualine.nvim
- bufferline.nvim
- indent-blankline.nvim
- nvim-web-devicons
- nvim-colorizer.lua

### Навигация
- nvim-tree.lua
- telescope.nvim
- telescope-fzf-native.nvim

### LSP & Автодополнение
- nvim-lspconfig
- mason.nvim
- mason-lspconfig.nvim
- nvim-cmp (+ источники: lsp, buffer, path, luasnip)
- LuaSnip
- friendly-snippets

### Подсветка и парсинг
- nvim-treesitter

### Утилиты
- nvim-autopairs
- Comment.nvim
- gitsigns.nvim
- todo-comments.nvim
- which-key.nvim

</details>

## 🎨 Скриншоты

> *TODO: Добавьте скриншот вашего рабочего окружения в `screenshot.png`*

## ⚙️ Настройка

Вся конфигурация находится в одном файле: **`init.lua`**

```bash
# Редактировать конфиг
nvim ~/.config/nvim/init.lua

# Перезагрузить после изменений
:source %
```

Подробная документация по модификации конфига в [CLAUDE.md](./CLAUDE.md)

## 🚀 Быстрый старт

После установки:

```bash
# Запустить Neovim
nvim

# Открыть файл
nvim hello.cpp
```

Внутри Neovim:
```vim
:Lazy          " Проверить плагины
:Mason         " Проверить LSP серверы
:checkhealth   " Проверить здоровье системы
```

## 📚 Документация

- **[CLAUDE.md](./CLAUDE.md)** - полная документация по конфигу
- **[install.sh](./install.sh)** - скрипт автоматической установки

## ❓ Troubleshooting

### LSP не работает
```vim
:LspInfo       " Проверить статус
:Mason         " Установить clangd
```

### Плагины не загружаются
```bash
nvim --headless "+Lazy! sync" +qa
```

### Ошибки при запуске
```vim
:checkhealth   " Диагностика
```

Полный список решений в [CLAUDE.md](./CLAUDE.md#troubleshooting)

## 🔧 Системные требования

- **OS**: Linux (Arch, Ubuntu, Debian)
- **Neovim**: 0.11 или новее
- **Память**: ~100MB для всех плагинов
- **Время запуска**: ~30-50ms

## 📄 Лицензия

MIT License - используйте свободно!

## 🤝 Вклад

Найдены баги или есть идеи? Открывайте issues!

---


