return {
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "rcarriga/nvim-dap-ui",
      "nvim-neotest/nvim-nio",
    },
    config = function()
      local dap = require("dap")
      local dapui = require("dapui")

      dapui.setup()

      -- auto open/close UI
      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close()
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close()
      end

      -- keymaps
      local map = function(keys, func, desc)
        vim.keymap.set("n", keys, func, { desc = "Debug: " .. desc })
      end
      map("<leader>db", dap.toggle_breakpoint, "Toggle Breakpoint")
      map("<leader>dB", function() dap.set_breakpoint(vim.fn.input("Breakpoint condition: ")) end, "Conditional Breakpoint")
      map("<leader>dc", dap.continue, "Continue")
      map("<leader>do", dap.step_over, "Step Over")
      map("<leader>di", dap.step_into, "Step Into")
      map("<leader>dO", dap.step_out, "Step Out")
      map("<leader>dr", dap.repl.toggle, "Toggle REPL")
      map("<leader>dl", dap.run_last, "Run Last")
      map("<leader>dt", dapui.toggle, "Toggle UI")
      map("<leader>dx", dap.terminate, "Terminate")

      ------------------------------------------------------------------
      -- Perl Debugging via native `perl-lsp` / `perllsp` DAP engine
      ------------------------------------------------------------------
      dap.adapters.perl = {
        type = "executable",
        command = "perl-dap",
        args = { "--stdio" },
      }

      dap.configurations.perl = {
        {
          type = "perl",
          name = "Debug current file",
          request = "launch",
          program = "${file}",
          cwd = "${workspaceFolder}",
          execArgs = { "-Ilib" },
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
    config = function()
      require("dap-python").setup("python3")
    end,
  },
}
