# 🚀 Neovim Configuration for C++ Development

![Neovim Screenshot](./screenshot.png) *(optional - сделайте скриншот вашего интерфейса)*

Modern Neovim config with VS Code-like experience featuring:
- Dark theme with blue accents
- Full LSP support for C++ (clangd)
- Fast navigation and autocompletion
- Custom keybindings for productivity

## 🛠 Installation

### Requirements
- Neovim 0.8+
- Git
- clangd (for C++ LSP)

### Quick Install
```bash
git clone https://github.com/kranks-uga/configNvim.git ~/.config/nvim
nvim --headless "+Lazy! sync" +qa
```

## ⌨️ Key Bindings

| Key          | Action                          |
|--------------|---------------------------------|
| `<leader>e`  | Toggle file tree (NvimTree)     |
| `<leader>ff` | Find files (Telescope)          |
| `<leader>fg` | Live grep (Telescope)           |
| `gd`         | Go to definition                |
| `K`          | Show documentation              |
| `<F5>`       | Compile & run C++               |

## 🧩 Features

### LSP & Autocompletion
- clangd for C++
- Snippets support
- Error diagnostics

### UI Enhancements
- Tokyonight storm theme
- Custom statusline
- File icons

## ⚙️ Customization
Edit these files:
- `lua/config/lsp.lua` - LSP settings
- `lua/config/colors.lua` - Color scheme tweaks

## ❓ Troubleshooting
If you get LSP errors:
```bash
sudo pacman -S clang cmake  # Arch Linux
nvim +LspInstall clangd
```
