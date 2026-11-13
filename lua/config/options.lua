local o = vim.opt

o.number = true
o.relativenumber = false
o.mouse = "a"
o.clipboard = "unnamedplus"
o.undofile = true
o.ignorecase = true
o.smartcase = true
o.signcolumn = "yes"
o.cursorline = true
o.scrolloff = 4
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
o.breakindent = true
o.inccommand = "split"
o.confirm = true
o.completeopt = "menu,menuone,noselect"

vim.diagnostic.config({
  virtual_text = false,
  severity_sort = true,
  float = { border = "rounded", source = true },
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = "E",
      [vim.diagnostic.severity.WARN] = "W",
      [vim.diagnostic.severity.INFO] = "I",
      [vim.diagnostic.severity.HINT] = "H",
    },
  },
})
