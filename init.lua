-- Точка входа. Leader должен быть задан ДО загрузки плагинов.
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Инструменты из cargo (tree-sitter, rust-analyzer) и go (nasmfmt) — в PATH,
-- даже если оболочка (например, fish) их туда не добавила.
for _, dir in ipairs({ "~/.cargo/bin", "~/go/bin" }) do
  dir = vim.fn.expand(dir)
  if vim.fn.isdirectory(dir) == 1 and not vim.env.PATH:find(dir, 1, true) then
    vim.env.PATH = dir .. ":" .. vim.env.PATH
  end
end

require("config.options")
require("config.keymaps")
require("config.autocmds")
require("config.lazy")
