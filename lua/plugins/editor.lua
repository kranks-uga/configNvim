return {
  -- Нечёткий поиск файлов / текста / всего
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    },
    cmd = "Telescope",
    keys = {
      { "<leader>ff", "<cmd>Telescope find_files<CR>", desc = "Найти файл" },
      { "<leader>fg", "<cmd>Telescope live_grep<CR>", desc = "Поиск текста (grep)" },
      { "<leader>fw", "<cmd>Telescope grep_string<CR>", desc = "Искать слово под курсором" },
      { "<leader>fb", "<cmd>Telescope buffers<CR>", desc = "Открытые буферы" },
      { "<leader>fr", "<cmd>Telescope oldfiles<CR>", desc = "Недавние файлы" },
      { "<leader>fs", "<cmd>Telescope lsp_document_symbols<CR>", desc = "Символы файла" },
      { "<leader>fS", "<cmd>Telescope lsp_dynamic_workspace_symbols<CR>", desc = "Символы проекта" },
      { "<leader>fd", "<cmd>Telescope diagnostics<CR>", desc = "Диагностика" },
      { "<leader>fh", "<cmd>Telescope help_tags<CR>", desc = "Справка nvim" },
      { "<leader>fk", "<cmd>Telescope keymaps<CR>", desc = "Все сочетания клавиш" },
      { "<leader><leader>", "<cmd>Telescope find_files<CR>", desc = "Найти файл" },
    },
    config = function()
      require("telescope").setup({})
      pcall(require("telescope").load_extension, "fzf")
    end,
  },

  -- Автозакрытие скобок
  { "windwp/nvim-autopairs", event = "InsertEnter", opts = {} },

  -- Окружение: ys / ds / cs  (ysiw" — обернуть слово в кавычки)
  { "kylechui/nvim-surround", version = "*", event = "VeryLazy", opts = {} },

  -- Git-метки на полях
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      on_attach = function(buf)
        local gs = require("gitsigns")
        local map = function(l, r, d) vim.keymap.set("n", l, r, { buffer = buf, desc = d }) end
        map("]h", function() gs.nav_hunk("next") end, "Следующее изменение")
        map("[h", function() gs.nav_hunk("prev") end, "Предыдущее изменение")
        map("<leader>gp", gs.preview_hunk, "Показать изменение")
        map("<leader>gr", gs.reset_hunk, "Откатить изменение")
        map("<leader>gb", gs.blame_line, "Кто написал строку")
      end,
    },
  },

  -- Подсветка TODO/FIXME
  { "folke/todo-comments.nvim", event = "VeryLazy", dependencies = { "nvim-lua/plenary.nvim" }, opts = {} },

  -- Синтаксис через tree-sitter
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    lazy = false,
    build = ":TSUpdate",
    config = function()
      local langs = {
        "c", "cpp", "rust", "asm", "nasm", "lua", "vim", "vimdoc", "query",
        "bash", "make", "cmake", "toml", "json", "yaml", "markdown", "markdown_inline",
      }
      require("nvim-treesitter").install(langs)
      vim.api.nvim_create_autocmd("FileType", {
        callback = function(ev)
          if pcall(vim.treesitter.start, ev.buf) then
            vim.bo[ev.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
          end
        end,
      })
    end,
  },
}
