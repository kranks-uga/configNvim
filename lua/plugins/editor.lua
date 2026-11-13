return {
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    cmd = "Telescope",
    keys = {
      { "<leader><leader>", "<cmd>Telescope find_files<CR>", desc = "Найти файл" },
      { "<leader>ff", "<cmd>Telescope find_files<CR>", desc = "Найти файл" },
      { "<leader>fg", "<cmd>Telescope live_grep<CR>", desc = "Поиск по тексту" },
      { "<leader>fb", "<cmd>Telescope buffers<CR>", desc = "Открытые файлы" },
      { "<leader>fh", "<cmd>Telescope help_tags<CR>", desc = "Справка" },
    },
    opts = {
      defaults = {
        layout_strategy = "horizontal",
        layout_config = { prompt_position = "top" },
        sorting_strategy = "ascending",
      },
    },
  },

  { "windwp/nvim-autopairs", event = "InsertEnter", opts = {} },

  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {},
  },

  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    lazy = false,
    build = ":TSUpdate",
    config = function()
      local langs = { "c", "cpp", "rust", "lua", "vim", "vimdoc", "query", "bash", "json", "yaml", "markdown", "markdown_inline" }
      require("nvim-treesitter").install(langs)
      vim.api.nvim_create_autocmd("FileType", {
        callback = function(ev)
          pcall(vim.treesitter.start, ev.buf)
        end,
      })
    end,
  },
}
