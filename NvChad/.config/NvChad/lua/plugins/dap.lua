return {
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "rcarriga/nvim-dap-ui",
      "nvim-neotest/nvim-nio",
    },
    keys = {
      { "<leader>db", function() require("dap").toggle_breakpoint() end, desc = "Debug: Toggle Breakpoint" },
      {
        "<leader>dB",
        function()
          require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))
        end,
        desc = "Debug: Conditional Breakpoint",
      },
      { "<leader>dc", function() require("dap").continue() end, desc = "Debug: Continue" },
      { "<leader>do", function() require("dap").step_over() end, desc = "Debug: Step Over" },
      { "<leader>di", function() require("dap").step_into() end, desc = "Debug: Step Into" },
      { "<leader>dO", function() require("dap").step_out() end, desc = "Debug: Step Out" },
      { "<leader>dr", function() require("dap").repl.toggle() end, desc = "Debug: Toggle REPL" },
      { "<leader>dl", function() require("dap").run_last() end, desc = "Debug: Run Last" },
      { "<leader>dt", function() require("dapui").toggle() end, desc = "Debug: Toggle UI" },
      { "<leader>dx", function() require("dap").terminate() end, desc = "Debug: Terminate" },
    },
    config = function()
      local dap = require "dap"
      local dapui = require "dapui"

      dapui.setup()

      -- Auto open/close UI
      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close()
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close()
      end

      ------------------------------------------------------------------
      -- Perl Debugging via native `perl-lsp` / `perllsp` DAP engine
      ------------------------------------------------------------------
      dap.adapters.perl = {
        type = "executable",
        command = "perllsp", -- or 'perl-dap' depending on your binary build
        args = { "dap" },
      }

      dap.configurations.perl = {
        {
          type = "perl",
          name = "Debug current file",
          request = "launch",
          program = "${file}",
          cwd = "${workspaceFolder}",
          execArgs = { "-Ilib" }, -- Pass library include paths or runtime flags here
          stopOnEntry = false,
        },
        {
          type = "perl",
          name = "Debug test file (prove)",
          request = "launch",
          program = "${file}",
          cwd = "${workspaceFolder}",
          execArgs = { "-Ilib", "-It/lib" },
        },
      }
    end,
  },

  {
    "mfussenegger/nvim-dap-python",
    ft = "python",
    config = function()
      require("dap-python").setup "python3"
    end,
  },
}
