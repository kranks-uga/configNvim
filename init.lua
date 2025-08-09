-- =============================================
--  Основные настройки
-- =============================================
vim.opt.number = true           -- Номера строк
vim.opt.tabstop = 4             -- Размер табуляции
vim.opt.shiftwidth = 4          -- Размер отступа
vim.opt.expandtab = true        -- Пробелы вместо табов
vim.opt.smartindent = true      -- Умные отступы
vim.opt.mouse = 'a'             -- Мышь во всех режимах
vim.opt.termguicolors = true    -- True-цвета
vim.opt.cursorline = true       -- Подсветка текущей строки
vim.opt.hidden = true           -- Фоновые буферы

-- =============================================
--  Установка плагинов (Lazy.nvim)
-- =============================================
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  -- Цветовая схема
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require("tokyonight").setup({
        style = "storm",
        on_colors = function(colors)
          colors.fg = "#a0a8d0"  -- Синий текст
          colors.fg_gutter = "#7eb6ff"
        end
      })
      vim.cmd.colorscheme("tokyonight")
    end
  },

  -- Иконки
  "kyazdani42/nvim-web-devicons",

  -- Статусная строка
  {
    "nvim-lualine/lualine.nvim",
    config = function()
      require("lualine").setup({
        options = {
          theme = "tokyonight",
          component_separators = { left = '', right = ''},
          section_separators = { left = '', right = ''},
        }
      })
    end
  },

  -- Дерево файлов
  {
    "nvim-tree/nvim-tree.lua",
    config = function()
      require("nvim-tree").setup({
        view = {
          width = 30,
        },
        renderer = {
          highlight_git = true,
          icons = {
            show = {
              git = true,
            },
          },
        },
      })
    end
  },

  -- LSP и автодополнение
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "hrsh7th/nvim-cmp",
      "hrsh7th/cmp-nvim-lsp",
      "L3MON4D3/LuaSnip",
    }
  },

  -- Подсветка синтаксиса
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = { "c", "cpp", "lua", "python" },
        highlight = { enable = true },
      })
    end
  },

  -- Поиск файлов
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" }
  },
})

-- =============================================
--  Настройка LSP для C++
-- =============================================
local lspconfig = require('lspconfig')
local cmp = require('cmp')

-- Настройка LSP через Mason
require("mason").setup()
require("mason-lspconfig").setup({
  ensure_installed = { "clangd" }
})

-- Настройка автодополнения
cmp.setup({
  snippet = {
    expand = function(args)
      require('luasnip').lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.abort(),
    ['<CR>'] = cmp.mapping.confirm({ select = true }),
  }),
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
  })
})

-- Настройка clangd для C++
lspconfig.clangd.setup({
  capabilities = require('cmp_nvim_lsp').default_capabilities(),
  on_attach = function(client, bufnr)
    -- Горячие клавиши только для C++
    local opts = { noremap=true, silent=true, buffer=bufnr }
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
    vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
    vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
  end
})

-- =============================================
--  Пользовательские горячие клавиши
-- =============================================
vim.g.mapleader = ","

-- Навигация
vim.keymap.set('n', '<leader>e', ':NvimTreeToggle<CR>')  -- Дерево файлов
vim.keymap.set('n', '<leader>ff', ':Telescope find_files<CR>')  -- Поиск файлов
vim.keymap.set('n', '<leader>fg', ':Telescope live_grep<CR>')  -- Поиск по тексту

-- Работа с кодом
vim.keymap.set('n', '<leader>w', ':w<CR>')  -- Сохранить
vim.keymap.set('n', '<leader>q', ':bd<CR>')  -- Закрыть буфер

-- Сборка C++ (F5 для компиляции и запуска)
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'cpp',
  callback = function()
    vim.keymap.set('n', '<F5>', ':!g++ -std=c++17 -Wall % -o %:r && ./%:r<CR>',
      { noremap = true, silent = true, buffer = true })
  end
})

-- =============================================
--  Дополнительные цветовые настройки
-- =============================================
vim.cmd([[
  highlight Normal guibg=#1a1b26 guifg=#c0caf5
  highlight Comment guifg=#7aa2f7
  highlight CursorLine guibg=#2a2a3a
  highlight Visual guibg=#3d59a1
]])
