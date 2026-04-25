-- =============================================
--  🚀 Современная конфигурация Neovim для C++
--  Совместимость: Neovim 0.11+
-- =============================================

-- =============================================
--  Основные настройки
-- =============================================
vim.g.mapleader = ","           -- Leader клавиша (должна быть в начале)
vim.g.maplocalleader = "\\"

-- Внешний вид
vim.opt.number = true           -- Номера строк
vim.opt.relativenumber = true   -- Относительные номера
vim.opt.cursorline = true       -- Подсветка текущей строки
vim.opt.signcolumn = "yes"      -- Всегда показывать колонку для знаков
vim.opt.termguicolors = true    -- True-цвета
vim.opt.pumheight = 10          -- Высота popup меню

-- Отступы и табуляция
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.breakindent = true

-- Поиск
vim.opt.ignorecase = true       -- Игнорировать регистр при поиске
vim.opt.smartcase = true        -- Умный поиск с учетом регистра

-- Прочее
vim.opt.mouse = 'a'             -- Мышь во всех режимах
vim.opt.clipboard = "unnamedplus" -- Общий буфер обмена с системой
vim.opt.updatetime = 250        -- Быстрое обновление
vim.opt.timeoutlen = 300        -- Время ожидания команд
vim.opt.splitright = true       -- Новые окна справа
vim.opt.splitbelow = true       -- Новые окна снизу
vim.opt.scrolloff = 8           -- Отступ при скролле
vim.opt.undofile = true         -- Сохранение истории отмены

-- Отключить swap файлы
vim.opt.swapfile = false
vim.opt.backup = false

-- =============================================
--  Установка плагинов (Lazy.nvim)
-- =============================================
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
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
  -- =============================================
  --  Цветовая схема и UI
  -- =============================================
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require("tokyonight").setup({
        style = "storm",
        transparent = false,
        on_colors = function(colors)
          colors.fg = "#a0a8d0"
          colors.fg_gutter = "#7eb6ff"
        end,
        on_highlights = function(hl, c)
          hl.CursorLineNr = { fg = c.orange, bold = true }
        end,
      })
      vim.cmd.colorscheme("tokyonight")
    end
  },

  -- Иконки
  "nvim-tree/nvim-web-devicons",

  -- Улучшенная статусная строка
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    config = function()
      require("lualine").setup({
        options = {
          theme = "tokyonight",
          component_separators = { left = '│', right = '│'},
          section_separators = { left = '', right = ''},
          globalstatus = true,
        },
        sections = {
          lualine_a = {'mode'},
          lualine_b = {'branch', 'diff'},
          lualine_c = {
            { 'filename', path = 1 },
            { 'diagnostics', sources = {'nvim_lsp'} }
          },
          lualine_x = {'encoding', 'fileformat', 'filetype'},
          lualine_y = {'progress'},
          lualine_z = {'location'}
        },
      })
    end
  },

  -- Bufferline для вкладок
  {
    "akinsho/bufferline.nvim",
    event = "VeryLazy",
    keys = {
      { "<Tab>", "<cmd>BufferLineCycleNext<cr>", desc = "Next buffer" },
      { "<S-Tab>", "<cmd>BufferLineCyclePrev<cr>", desc = "Prev buffer" },
      { "<leader>x", "<cmd>bd<cr>", desc = "Close buffer" },
    },
    opts = {
      options = {
        mode = "buffers",
        separator_style = "slant",
        always_show_bufferline = false,
        show_buffer_close_icons = false,
        show_close_icon = false,
        diagnostics = "nvim_lsp",
      },
    },
  },

  -- Indent guides
  {
    "lukas-reineke/indent-blankline.nvim",
    event = { "BufReadPost", "BufNewFile" },
    main = "ibl",
    opts = {
      indent = { char = "│" },
      scope = { enabled = false },
    },
  },

  -- =============================================
  --  Файловый менеджер и навигация
  -- =============================================
  {
    "nvim-tree/nvim-tree.lua",
    cmd = { "NvimTreeToggle", "NvimTreeFocus" },
    keys = {
      { "<leader>e", "<cmd>NvimTreeToggle<cr>", desc = "Toggle file tree" },
    },
    opts = {
      view = {
        width = 35,
        side = "left",
      },
      renderer = {
        highlight_git = true,
        group_empty = true,
        icons = {
          show = {
            git = true,
            folder = true,
            file = true,
          },
        },
      },
      filters = {
        dotfiles = false,
        custom = { "^.git$", "^node_modules$" },
      },
    },
  },

  -- Telescope - поиск файлов и текста
  {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
    dependencies = {
      "nvim-lua/plenary.nvim",
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
      },
    },
    keys = {
      { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find files" },
      { "<leader>fg", "<cmd>Telescope live_grep<cr>", desc = "Live grep" },
      { "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "Buffers" },
      { "<leader>fh", "<cmd>Telescope help_tags<cr>", desc = "Help" },
      { "<leader>fr", "<cmd>Telescope oldfiles<cr>", desc = "Recent files" },
    },
    config = function()
      local telescope = require("telescope")
      telescope.setup({
        defaults = {
          prompt_prefix = " 🔍 ",
          selection_caret = " ➜ ",
          path_display = { "smart" },
          file_ignore_patterns = { "node_modules", ".git/", "*.o", "*.out" },
        },
      })
      telescope.load_extension("fzf")
    end,
  },

  -- =============================================
  --  LSP и автодополнение
  -- =============================================
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "hrsh7th/cmp-nvim-lsp",
    },
    config = function()
      local cmp_nvim_lsp = require('cmp_nvim_lsp')

      vim.lsp.config('*', {
        capabilities = cmp_nvim_lsp.default_capabilities(),
      })

      vim.lsp.config('clangd', {
        cmd = {
          "clangd",
          "--background-index",
          "--clang-tidy",
          "--header-insertion=iwyu",
          "--completion-style=detailed",
          "--function-arg-placeholders",
        },
        init_options = {
          clangdFileStatus = true,
          usePlaceholders = true,
          completeUnimported = true,
          semanticHighlighting = true,
        },
      })

      vim.lsp.enable('clangd')

      vim.diagnostic.config({
        virtual_text = { prefix = '●', source = "if_many" },
        float = { source = "always", border = "rounded" },
        signs = true,
        underline = true,
        update_in_insert = false,
        severity_sort = true,
      })

      local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
      for type, icon in pairs(signs) do
        local hl = "DiagnosticSign" .. type
        vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
      end
    end,
  },

  -- Mason - менеджер LSP серверов
  {
    "williamboman/mason.nvim",
    cmd = "Mason",
    build = ":MasonUpdate",
    opts = {
      ui = {
        border = "rounded",
        icons = {
          package_installed = "✓",
          package_pending = "➜",
          package_uninstalled = "✗"
        }
      }
    },
  },

  {
    "williamboman/mason-lspconfig.nvim",
    opts = {
      ensure_installed = { "clangd" },
      automatic_installation = true,
    },
  },

  -- Автодополнение
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",     -- LSP источник
      "hrsh7th/cmp-buffer",        -- Буфер источник
      "hrsh7th/cmp-path",          -- Пути источник
      "L3MON4D3/LuaSnip",          -- Snippet движок
      "saadparwaiz1/cmp_luasnip",  -- Snippet источник
      "rafamadriz/friendly-snippets", -- Готовые snippets
    },
    config = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")

      -- Загрузка готовых snippets
      require("luasnip.loaders.from_vscode").lazy_load()

      cmp.setup({
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        window = {
          completion = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        },
        mapping = cmp.mapping.preset.insert({
          ['<C-b>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),
          ['<C-Space>'] = cmp.mapping.complete(),
          ['<C-e>'] = cmp.mapping.abort(),
          ['<CR>'] = cmp.mapping.confirm({ select = true }),
          ['<Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end, { 'i', 's' }),
          ['<S-Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { 'i', 's' }),
        }),
        sources = cmp.config.sources({
          { name = 'nvim_lsp', priority = 1000 },
          { name = 'luasnip', priority = 750 },
          { name = 'buffer', priority = 500 },
          { name = 'path', priority = 250 },
        }),
        formatting = {
          format = function(entry, vim_item)
            -- Иконки для типов
            local icons = {
              Text = "󰉿",
              Method = "󰆧",
              Function = "󰊕",
              Constructor = "",
              Field = "󰜢",
              Variable = "󰀫",
              Class = "󰠱",
              Interface = "",
              Module = "",
              Property = "󰜢",
              Unit = "󰑭",
              Value = "󰎠",
              Enum = "",
              Keyword = "󰌋",
              Snippet = "",
              Color = "󰏘",
              File = "󰈙",
              Reference = "󰈇",
              Folder = "󰉋",
              EnumMember = "",
              Constant = "󰏿",
              Struct = "󰙅",
              Event = "",
              Operator = "󰆕",
              TypeParameter = "",
            }
            vim_item.kind = string.format('%s %s', icons[vim_item.kind] or "", vim_item.kind)
            vim_item.menu = ({
              nvim_lsp = "[LSP]",
              luasnip = "[Snip]",
              buffer = "[Buf]",
              path = "[Path]",
            })[entry.source.name]
            return vim_item
          end,
        },
      })
    end,
  },

  -- Подсветка синтаксиса
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      require('nvim-treesitter').install({
        'c', 'cpp', 'lua', 'python', 'bash', 'json', 'markdown',
      })
    end,
  },

  -- =============================================
  --  Дополнительные плагины для удобства
  -- =============================================

  -- Автозакрытие скобок
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    opts = {
      check_ts = true,
      ts_config = {
        lua = { "string" },
        cpp = { "string" },
      },
    },
  },

  -- Комментирование кода
  {
    "numToStr/Comment.nvim",
    keys = {
      { "gcc", mode = "n", desc = "Comment line" },
      { "gc", mode = { "n", "v" }, desc = "Comment" },
    },
    opts = {},
  },

  -- Подсветка цветов
  {
    "norcalli/nvim-colorizer.lua",
    event = "BufReadPre",
    config = function()
      require("colorizer").setup()
    end,
  },

  -- Git integration
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      signs = {
        add = { text = "│" },
        change = { text = "│" },
        delete = { text = "_" },
        topdelete = { text = "‾" },
        changedelete = { text = "~" },
      },
    },
  },

  -- Подсветка TODO комментариев
  {
    "folke/todo-comments.nvim",
    event = { "BufReadPost", "BufNewFile" },
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {},
  },

  -- Which-key для подсказок горячих клавиш
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {},
  },
}, {
  ui = {
    border = "rounded",
  },
  performance = {
    rtp = {
      disabled_plugins = {
        "gzip",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
})

-- =============================================
--  LSP горячие клавиши (через LspAttach)
-- =============================================
vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(args)
    local opts = { noremap = true, silent = true, buffer = args.buf }
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
    vim.keymap.set('n', 'gt', vim.lsp.buf.type_definition, opts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
    vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
    vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
    vim.keymap.set({'n', 'v'}, '<leader>ca', vim.lsp.buf.code_action, opts)
    vim.keymap.set('n', '<leader>f', function()
      vim.lsp.buf.format({ async = true })
    end, opts)
    vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
    vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
    vim.keymap.set('n', '<leader>d', vim.diagnostic.open_float, opts)
  end,
})

-- =============================================
--  Пользовательские горячие клавиши
-- =============================================

-- Навигация
vim.keymap.set('n', '<leader>w', ':w<CR>', { desc = "Save file" })
vim.keymap.set('n', '<leader>q', ':bd<CR>', { desc = "Close buffer" })
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>', { desc = "Clear search highlight" })

-- Перемещение строк
vim.keymap.set('v', 'J', ":m '>+1<CR>gv=gv", { desc = "Move line down" })
vim.keymap.set('v', 'K', ":m '<-2<CR>gv=gv", { desc = "Move line up" })

-- Лучшее редактирование
vim.keymap.set('n', 'J', 'mzJ`z', { desc = "Join lines" })
vim.keymap.set('x', '<leader>p', '"_dP', { desc = "Paste without yanking" })

-- Навигация между окнами
vim.keymap.set('n', '<C-h>', '<C-w>h', { desc = "Go to left window" })
vim.keymap.set('n', '<C-j>', '<C-w>j', { desc = "Go to lower window" })
vim.keymap.set('n', '<C-k>', '<C-w>k', { desc = "Go to upper window" })
vim.keymap.set('n', '<C-l>', '<C-w>l', { desc = "Go to right window" })

-- Изменение размера окон
vim.keymap.set('n', '<C-Up>', '<cmd>resize +2<cr>', { desc = "Increase window height" })
vim.keymap.set('n', '<C-Down>', '<cmd>resize -2<cr>', { desc = "Decrease window height" })
vim.keymap.set('n', '<C-Left>', '<cmd>vertical resize -2<cr>', { desc = "Decrease window width" })
vim.keymap.set('n', '<C-Right>', '<cmd>vertical resize +2<cr>', { desc = "Increase window width" })

-- Быстрая навигация по файлу
vim.keymap.set('n', '<C-d>', '<C-d>zz', { desc = "Scroll down" })
vim.keymap.set('n', '<C-u>', '<C-u>zz', { desc = "Scroll up" })
vim.keymap.set('n', 'n', 'nzzzv', { desc = "Next search result" })
vim.keymap.set('n', 'N', 'Nzzzv', { desc = "Previous search result" })

-- =============================================
--  C++ специфичные настройки
-- =============================================
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'cpp',
  callback = function()
    -- F5 для компиляции и запуска
    vim.keymap.set('n', '<F5>', function()
      vim.cmd('write')
      local file = vim.fn.expand('%')
      local output = vim.fn.expand('%:r')
      local cmd = string.format('!g++ -std=c++17 -Wall -Wextra -O2 %s -o %s && ./%s', file, output, output)
      vim.cmd(cmd)
    end, { buffer = true, desc = "Compile and run C++" })

    -- F6 для только компиляции
    vim.keymap.set('n', '<F6>', function()
      vim.cmd('write')
      local file = vim.fn.expand('%')
      local output = vim.fn.expand('%:r')
      local cmd = string.format('!g++ -std=c++17 -Wall -Wextra -O2 %s -o %s', file, output)
      vim.cmd(cmd)
    end, { buffer = true, desc = "Compile C++" })

    -- F7 для debug компиляции
    vim.keymap.set('n', '<F7>', function()
      vim.cmd('write')
      local file = vim.fn.expand('%')
      local output = vim.fn.expand('%:r') .. '_debug'
      local cmd = string.format('!g++ -std=c++17 -Wall -Wextra -g -DDEBUG %s -o %s && ./%s', file, output, output)
      vim.cmd(cmd)
    end, { buffer = true, desc = "Debug compile and run C++" })
  end
})

-- =============================================
--  Дополнительные цветовые настройки
-- =============================================
vim.cmd([[
  highlight Normal guibg=#1a1b26 guifg=#c0caf5
  highlight Comment guifg=#7aa2f7 gui=italic
  highlight CursorLine guibg=#2a2a3a
  highlight Visual guibg=#3d59a1
  highlight NormalFloat guibg=#1f2335
  highlight FloatBorder guifg=#7aa2f7 guibg=#1f2335
]])

-- Приветственное сообщение
vim.api.nvim_create_autocmd("VimEnter", {
  once = true,
  callback = function()
    print("🚀 Neovim готов к работе!")
  end,
})
