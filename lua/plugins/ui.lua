return {
  -- Тема
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require("tokyonight").setup({ style = "night" })
      vim.cmd.colorscheme("tokyonight")
    end,
  },

  -- Статус-строка
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = { options = { theme = "tokyonight", globalstatus = true } },
  },

  -- Вкладки буферов сверху
  {
    "akinsho/bufferline.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = { options = { diagnostics = "nvim_lsp", offsets = { { filetype = "neo-tree", text = "Файлы" } } } },
  },

  -- Подсказка по клавишам: нажми <Space> и подожди
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      preset = "modern",
      spec = {
        { "<leader>f", group = "Поиск (find)" },
        { "<leader>d", group = "Отладка (debug)" },
        { "<leader>g", group = "Git" },
        { "<leader>c", group = "Код" },
        { "<leader>t", group = "Список ошибок (trouble)" },
      },
    },
  },

  -- Дерево файлов
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = { "nvim-lua/plenary.nvim", "nvim-tree/nvim-web-devicons", "MunifTanjim/nui.nvim" },
    cmd = "Neotree",
    keys = { { "<leader>n", "<cmd>Neotree toggle reveal<CR>", desc = "Дерево файлов" } },
    opts = { filesystem = { follow_current_file = { enabled = true } } },
  },

  -- Плавающий терминал: Ctrl+\
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    keys = { { [[<C-\>]], desc = "Терминал" } },
    opts = { open_mapping = [[<C-\>]], direction = "float" },
  },

  -- Список всех ошибок проекта
  {
    "folke/trouble.nvim",
    cmd = "Trouble",
    opts = {},
    keys = {
      { "<leader>tt", "<cmd>Trouble diagnostics toggle<CR>", desc = "Ошибки проекта" },
      { "<leader>tb", "<cmd>Trouble diagnostics toggle filter.buf=0<CR>", desc = "Ошибки файла" },
      { "<leader>ts", "<cmd>Trouble symbols toggle<CR>", desc = "Символы файла" },
    },
  },
}
