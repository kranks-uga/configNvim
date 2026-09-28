local o = vim.opt

o.number = true            -- номера строк
o.relativenumber = true    -- относительные номера (удобно для 5j, 3dd и т.п.)
o.mouse = "a"
o.clipboard = "unnamedplus" -- общий буфер обмена с системой
o.undofile = true          -- история undo сохраняется между сессиями
o.ignorecase = true
o.smartcase = true         -- поиск чувствителен к регистру, если есть заглавные
o.signcolumn = "yes"
o.cursorline = true
o.scrolloff = 8
o.splitright = true
o.splitbelow = true
o.termguicolors = true
o.updatetime = 250
o.timeoutlen = 400
o.expandtab = true
o.shiftwidth = 4
o.tabstop = 4
o.smartindent = true
o.wrap = false
o.list = true
o.listchars = { tab = "» ", trail = "·", nbsp = "␣" }
o.inccommand = "split"     -- живой предпросмотр :s/../../
o.confirm = true
o.completeopt = "menu,menuone,noselect"
o.winborder = "rounded"    -- рамки у всплывающих окон (hover, signature)

vim.diagnostic.config({
  virtual_text = { spacing = 2, prefix = "●" },
  severity_sort = true,
  float = { border = "rounded", source = true },
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = " ",
      [vim.diagnostic.severity.WARN] = " ",
      [vim.diagnostic.severity.INFO] = " ",
      [vim.diagnostic.severity.HINT] = "󰌵 ",
    },
  },
})

-- .asm / .nasm / .inc -> NASM-синтаксис; .s / .S остаются GAS (asm)
vim.filetype.add({
  extension = { asm = "nasm", nasm = "nasm" },
})
