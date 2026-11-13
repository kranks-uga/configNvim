return {
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require("tokyonight").setup({
        style = "night",
        transparent = true,
        styles = { sidebars = "transparent", floats = "transparent" },
      })
      vim.cmd.colorscheme("tokyonight")
    end,
  },

  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      options = {
        theme = "tokyonight",
        globalstatus = true,
        section_separators = "",
        component_separators = "",
      },
      sections = {
        lualine_a = { "mode" },
        lualine_b = { "branch" },
        lualine_c = { { "filename", path = 1 } },
        lualine_x = { "diagnostics", "filetype" },
        lualine_y = { "progress" },
        lualine_z = { "location" },
      },
    },
  },

  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      preset = "helix",
      spec = {
        { "<leader>f", group = "Поиск" },
        { "<leader>c", group = "Код" },
      },
    },
  },

  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = { "nvim-lua/plenary.nvim", "nvim-tree/nvim-web-devicons", "MunifTanjim/nui.nvim" },
    cmd = "Neotree",
    keys = {
      { "<leader>e", "<cmd>Neotree toggle<CR>", desc = "Файлы" },
    },
    opts = {
      close_if_last_window = true,
      filesystem = {
        follow_current_file = { enabled = true },
        filtered_items = { hide_dotfiles = false, hide_gitignored = false },
      },
      window = { width = 30 },
    },
  },
}
