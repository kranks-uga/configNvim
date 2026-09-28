return {
  -- Mason: ставит LSP-серверы и инструменты в ~/.local/share/nvim/mason (без sudo)
  { "mason-org/mason.nvim", cmd = "Mason", opts = {} },
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    dependencies = { "mason-org/mason.nvim" },
    event = "VeryLazy",
    opts = {
      ensure_installed = { "clangd", "clang-format", "asm-lsp", "codelldb", "lua-language-server" },
    },
  },

  -- Для редактирования этого конфига: знает API Neovim
  { "folke/lazydev.nvim", ft = "lua", opts = {} },

  -- Готовые конфиги серверов + сама настройка LSP
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = { "mason-org/mason.nvim", "saghen/blink.cmp" },
    config = function()
      require("mason").setup() -- добавляет mason/bin в PATH

      vim.lsp.config("*", { capabilities = require("blink.cmp").get_lsp_capabilities() })

      vim.lsp.config("clangd", {
        cmd = {
          "clangd", "--background-index", "--clang-tidy", "--header-insertion=iwyu",
          "--completion-style=detailed", "--function-arg-placeholders", "--fallback-style=llvm",
        },
      })

      -- rust-analyzer берётся из rustup (~/.cargo/bin), не из Mason
      vim.lsp.config("rust_analyzer", {
        settings = {
          ["rust-analyzer"] = {
            check = { command = "clippy" },
            cargo = { allFeatures = true },
          },
        },
      })

      vim.lsp.config("asm_lsp", { filetypes = { "asm", "nasm", "vmasm" } })

      vim.lsp.enable({ "clangd", "rust_analyzer", "asm_lsp", "lua_ls" })

      -- Клавиши, активные только когда к буферу подключён LSP
      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(ev)
          local map = function(l, r, d) vim.keymap.set("n", l, r, { buffer = ev.buf, desc = d }) end
          local tb = function(name) return function() require("telescope.builtin")[name]() end end
          map("gd", tb("lsp_definitions"), "Перейти к определению")
          map("gD", vim.lsp.buf.declaration, "Перейти к объявлению")
          -- Стандартные клавиши Neovim 0.12 (grn — rename, gra — code action), но через Telescope:
          map("grr", tb("lsp_references"), "Где используется")
          map("gri", tb("lsp_implementations"), "Реализации")
          map("grt", tb("lsp_type_definitions"), "Определение типа")
          map("K", vim.lsp.buf.hover, "Документация")
          map("<leader>cr", vim.lsp.buf.rename, "Переименовать")
          map("<leader>ca", vim.lsp.buf.code_action, "Действия (quick fix)")
          map("<leader>ch", function()
            vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = ev.buf }), { bufnr = ev.buf })
          end, "Вкл/выкл подсказки типов")
          vim.keymap.set("i", "<C-k>", vim.lsp.buf.signature_help, { buffer = ev.buf, desc = "Сигнатура функции" })

          local client = vim.lsp.get_client_by_id(ev.data.client_id)
          if client and client.name == "clangd" then
            map("<leader>co", "<cmd>LspClangdSwitchSourceHeader<CR>", "Переключить .h <-> .cpp")
          end
          if client and client.name == "rust_analyzer" then
            vim.lsp.inlay_hint.enable(true, { bufnr = ev.buf })
          end
        end,
      })
    end,
  },

  -- Автодополнение
  {
    "saghen/blink.cmp",
    version = "1.*",
    dependencies = { "rafamadriz/friendly-snippets" },
    opts = {
      -- Enter — принять, Tab/Shift-Tab — выбор и прыжки по сниппету, Ctrl+Space — открыть меню
      keymap = { preset = "enter", ["<Tab>"] = { "select_next", "snippet_forward", "fallback" },
                 ["<S-Tab>"] = { "select_prev", "snippet_backward", "fallback" } },
      completion = { documentation = { auto_show = true, auto_show_delay_ms = 300 } },
      signature = { enabled = true },
      sources = { default = { "lsp", "path", "snippets", "buffer" } },
    },
  },

  -- Форматирование
  {
    "stevearc/conform.nvim",
    event = "BufWritePre",
    cmd = "ConformInfo",
    keys = {
      { "<leader>cf", function() require("conform").format({ async = true, lsp_format = "fallback" }) end, desc = "Отформатировать" },
      {
        "<leader>cF",
        function()
          vim.g.noformat = not vim.g.noformat
          vim.notify("Автоформат при сохранении: " .. (vim.g.noformat and "ВЫКЛ" or "ВКЛ"))
        end,
        desc = "Вкл/выкл автоформат",
      },
    },
    opts = {
      formatters_by_ft = {
        c = { "clang-format" },
        cpp = { "clang-format" },
        rust = { "rustfmt" },
        nasm = { "nasmfmt" },
        lua = { lsp_format = "prefer" },
      },
      formatters = {
        -- Если в проекте нет своего .clang-format — берём ~/.config/nvim/.clang-format (LLVM, отступ 4)
        ["clang-format"] = {
          prepend_args = function(_, ctx)
            local own = vim.fs.find({ ".clang-format", "_clang-format" }, { upward = true, path = ctx.dirname })[1]
            if own then return {} end
            return { "--style=file:" .. vim.fn.stdpath("config") .. "/.clang-format" }
          end,
        },
        -- nasmfmt правит файл на месте, поэтому stdin = false (conform даст ему временную копию)
        nasmfmt = {
          command = vim.fn.exepath("nasmfmt") ~= "" and "nasmfmt" or vim.fn.expand("~/go/bin/nasmfmt"),
          args = { "$FILENAME" },
          stdin = false,
        },
      },
      -- Автоформат при сохранении. Выключить/включить: Space cF
      format_on_save = function()
        if vim.g.noformat then return end
        return { timeout_ms = 1000, lsp_format = "fallback" }
      end,
    },
  },
}
