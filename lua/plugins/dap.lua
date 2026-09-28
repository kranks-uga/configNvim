-- Отладчик. C/C++/Rust — через codelldb (из Mason), ASM — через gdb (встроенный DAP в gdb 14+).
return {
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      { "rcarriga/nvim-dap-ui", dependencies = { "nvim-neotest/nvim-nio" } },
      "theHamsta/nvim-dap-virtual-text",
    },
    keys = {
      { "<F5>", function() require("dap").continue() end, desc = "Отладка: старт/продолжить" },
      { "<F10>", function() require("dap").step_over() end, desc = "Шаг через" },
      { "<F11>", function() require("dap").step_into() end, desc = "Шаг внутрь" },
      { "<F12>", function() require("dap").step_out() end, desc = "Шаг наружу" },
      { "<leader>db", function() require("dap").toggle_breakpoint() end, desc = "Точка останова" },
      { "<leader>dB", function() require("dap").set_breakpoint(vim.fn.input("Условие: ")) end, desc = "Условная точка останова" },
      { "<leader>dc", function() require("dap").continue() end, desc = "Старт/продолжить" },
      { "<leader>dr", function() require("dap").run_to_cursor() end, desc = "Выполнить до курсора" },
      { "<leader>dt", function() require("dap").terminate() end, desc = "Остановить" },
      { "<leader>du", function() require("dapui").toggle() end, desc = "Показать/скрыть панели" },
      { "<leader>de", function() require("dapui").eval() end, mode = { "n", "v" }, desc = "Значение выражения" },
    },
    config = function()
      local dap, dapui = require("dap"), require("dapui")
      dapui.setup()
      require("nvim-dap-virtual-text").setup({})

      dap.listeners.after.event_initialized.dapui = function() dapui.open() end
      dap.listeners.before.event_terminated.dapui = function() dapui.close() end
      dap.listeners.before.event_exited.dapui = function() dapui.close() end

      vim.fn.sign_define("DapBreakpoint", { text = "●", texthl = "DiagnosticError" })
      vim.fn.sign_define("DapStopped", { text = "→", texthl = "DiagnosticWarn", linehl = "Visual" })

      dap.adapters.codelldb = { type = "executable", command = vim.fn.stdpath("data") .. "/mason/bin/codelldb" }
      dap.adapters.gdb = { type = "executable", command = "gdb", args = { "--interpreter=dap", "--eval-command", "set print pretty on" } }

      -- По умолчанию предлагаем бинарник рядом с файлом (так его собирает <leader>b)
      local function program()
        return vim.fn.input("Бинарник: ", vim.fn.expand("%:p:r"), "file")
      end

      local lldb = {
        { name = "Запустить", type = "codelldb", request = "launch", program = program, cwd = "${workspaceFolder}", stopOnEntry = false },
      }
      dap.configurations.c = lldb
      dap.configurations.cpp = lldb
      dap.configurations.rust = {
        {
          name = "Запустить (cargo build)", type = "codelldb", request = "launch", cwd = "${workspaceFolder}",
          program = function()
            local root = vim.fs.root(0, "Cargo.toml")
            if root then
              vim.fn.system({ "cargo", "build", "--manifest-path", root .. "/Cargo.toml" })
              return vim.fn.input("Бинарник: ", root .. "/target/debug/" .. vim.fn.fnamemodify(root, ":t"), "file")
            end
            return program()
          end,
        },
      }
      local gdb = {
        { name = "Запустить (gdb)", type = "gdb", request = "launch", program = program, cwd = "${workspaceFolder}", stopAtBeginningOfMainSubprogram = false },
      }
      dap.configurations.nasm = gdb
      dap.configurations.asm = gdb
    end,
  },
}
