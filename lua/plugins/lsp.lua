return {
  { "mason-org/mason.nvim", cmd = "Mason", opts = {} },
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    dependencies = { "mason-org/mason.nvim" },
    opts = { ensure_installed = { "lua-language-server", "clangd", "clang-format" } },
  },

  { "folke/lazydev.nvim", ft = "lua", opts = {} },

  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = { "mason-org/mason.nvim", "saghen/blink.cmp" },
    config = function()
      require("mason").setup()
      vim.lsp.config("*", { capabilities = require("blink.cmp").get_lsp_capabilities() })

      vim.lsp.config("clangd", {
        cmd = { "clangd", "--background-index", "--clang-tidy", "--header-insertion=iwyu" },
      })

      vim.lsp.enable({ "clangd", "lua_ls", "rust_analyzer" })

      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(ev)
          local map = function(lhs, rhs, desc)
            vim.keymap.set("n", lhs, rhs, { buffer = ev.buf, desc = desc })
          end
          map("gd", vim.lsp.buf.definition, "Перейти к определению")
          map("gr", vim.lsp.buf.references, "Где используется")
          map("K", vim.lsp.buf.hover, "Документация")
          map("<leader>cr", vim.lsp.buf.rename, "Переименовать")
          map("<leader>ca", vim.lsp.buf.code_action, "Действия с кодом")
          map("<leader>cf", function() require("conform").format({ async = true, lsp_format = "fallback" }) end, "Форматировать")
        end,
      })
    end,
  },

  {
    "saghen/blink.cmp",
    version = "1.*",
    dependencies = { "rafamadriz/friendly-snippets" },
    opts = {
      keymap = {
        preset = "enter",
        ["<Tab>"] = { "select_next", "snippet_forward", "fallback" },
        ["<S-Tab>"] = { "select_prev", "snippet_backward", "fallback" },
      },
      completion = { documentation = { auto_show = false } },
      signature = { enabled = true },
      sources = { default = { "lsp", "path", "snippets", "buffer" } },
    },
  },

  {
    "stevearc/conform.nvim",
    event = "BufWritePre",
    opts = {
      formatters_by_ft = {
        c = { "clang-format" },
        cpp = { "clang-format" },
        rust = { "rustfmt" },
        lua = { lsp_format = "prefer" },
      },
      format_on_save = { timeout_ms = 1000, lsp_format = "fallback" },
    },
  },
}
