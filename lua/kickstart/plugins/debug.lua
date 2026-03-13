-- debug.lua
--
-- Shows how to use the DAP plugin to debug your code.
--
-- Primarily focused on configuring the debugger for Go, but can
-- be extended to other languages as well. That's why it's called
-- kickstart.nvim and not kitchen-sink.nvim ;)

return {
  {
    'mfussenegger/nvim-dap',
    dependencies = {
      -- Creates a beautiful debugger UI
      'rcarriga/nvim-dap-ui',

      -- Required dependency for nvim-dap-ui
      'nvim-neotest/nvim-nio',

      -- Installs the debug adapters for you
      'mason-org/mason.nvim',
      'jay-babu/mason-nvim-dap.nvim',

      -- Telescope plugin
      'nvim-telescope/telescope-dap.nvim',

      -- Add your own debuggers here
      'leoluz/nvim-dap-go',
      "mrcjkb/rustaceanvim",
    },
    keys = {
      -- Basic debugging keymaps, feel free to change to your liking!
      {
        '<F5>',
        function() require('dap').continue() end,
        desc = 'Debug: Start/Continue',
      },
      {
        '<F1>',
        function() require('dap').step_into() end,
        desc = 'Debug: Step Into',
      },
      {
        '<F2>',
        function() require('dap').step_over() end,
        desc = 'Debug: Step Over',
      },
      {
        '<F3>',
        function() require('dap').step_out() end,
        desc = 'Debug: Step Out',
      },
      -- Toggle to see last session result. Without this, you can't see session output in case of unhandled exception.
      {
        '<F7>',
        function() require('dapui').toggle() end,
        desc = 'Debug: See last session result.',
      },
      { '<leader>fdc', function() require('telescope').extensions.dap.commands {} end,         desc = 'Search [D]ebug [C]ommands' },
      { '<leader>fdg', function() require('telescope').extensions.dap.configurations {} end,   desc = 'Search [D]ebug [G]o (Configs)' },
      { '<leader>fdb', function() require('telescope').extensions.dap.list_breakpoints {} end, desc = 'Search [D]ebug [B]reakpoints' },
      { '<leader>fdv', function() require('telescope').extensions.dap.variables {} end,        desc = 'Search [D]ebug [V]ariables' },
      { '<leader>fdf', function() require('telescope').extensions.dap.frames {} end,           desc = 'Search [D]ebug [F]rames' },
    },
    config = function()
      local dap = require 'dap'
      local dapui = require 'dapui'

      require('telescope').load_extension('dap')

      require('mason-nvim-dap').setup {
        -- Makes a best effort to setup the various debuggers with
        -- reasonable debug configurations
        automatic_installation = true,

        -- You can provide additional configuration to the handlers,
        -- see mason-nvim-dap README for more information
        handlers = {},

        -- You'll need to check that you have the required things installed
        -- online, please don't ask me how to install them :)
        ensure_installed = {
          -- Update this to ensure that you have the debuggers for the langs you want
          'delve',
        },
      }

      -- Dap UI setup
      -- For more information, see |:help nvim-dap-ui|
      dapui.setup {
        -- Set icons to characters that are more likely to work in every terminal.
        --    Feel free to remove or use ones that you like more! :)
        --    Don't feel like these are good choices.
        icons = { expanded = '▾', collapsed = '▸', current_frame = '*' },
        controls = {
          icons = {
            pause = '⏸',
            play = '▶',
            step_into = '⏎',
            step_over = '⏭',
            step_out = '⏮',
            step_back = 'b',
            run_last = '▶▶',
            terminate = '⏹',
            disconnect = '⏏',
          },
        },
      }

      -- Change breakpoint icons
      vim.api.nvim_set_hl(0, 'DapBreak', { fg = '#e51400' })
      vim.api.nvim_set_hl(0, 'DapStop', { fg = '#ffcc00' })
      local breakpoint_icons = vim.g.have_nerd_font
          and { Breakpoint = '', BreakpointCondition = '', BreakpointRejected = '', LogPoint = '', Stopped = '' }
          or { Breakpoint = '●', BreakpointCondition = '⊜', BreakpointRejected = '⊘', LogPoint = '◆', Stopped = '⭔' }
      for type, icon in pairs(breakpoint_icons) do
        local tp = 'Dap' .. type
        local hl = (type == 'Stopped') and 'DapStop' or 'DapBreak'
        vim.fn.sign_define(tp, { text = icon, texthl = hl, numhl = hl })
      end

      dap.listeners.after.event_initialized['dapui_config'] = dapui.open
      dap.listeners.before.event_terminated['dapui_config'] = dapui.close
      dap.listeners.before.event_exited['dapui_config'] = dapui.close

      -- Install golang specific config
      require('dap-go').setup {
        delve = {
          -- On Windows delve must be run attached or it crashes.
          -- See https://github.com/leoluz/nvim-dap-go/blob/main/README.md#configuring
          detached = vim.fn.has 'win32' == 0,
        },
      }
    end,
  },
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-neotest/nvim-nio",
      "nvim-lua/plenary.nvim",
      "antoinemadec/FixCursorHold.nvim",
      "nvim-treesitter/nvim-treesitter"
    }
  },
  {
    "Weissle/persistent-breakpoints.nvim",
    event = "BufReadPost",
    keys = {
      { '<leader>db', function() require('persistent-breakpoints.api').toggle_breakpoint() end,          desc = 'Toggle [B]reakpoint' },
      { '<leader>dB', function() require('persistent-breakpoints.api').set_conditional_breakpoint() end, desc = 'Conditional Breakpoint' },
      { '<leader>dc', function() require('persistent-breakpoints.api').clear_all_breakpoints() end,      desc = '[C]lear Breakpoints' },
      { '<leader>dl', function() require('persistent-breakpoints.api').set_log_point() end,              desc = 'Set [L]og Point' },
    },
    config = function()
      require('persistent-breakpoints').setup {
        save_dir = vim.fn.stdpath('data') .. '/nvim_checkpoints',
        -- when to load the breakpoints? "BufReadPost" is recommanded.
        load_breakpoints_event = { "BufReadPost" },
        -- record the performance of different function. run :lua require('persistent-breakpoints.api').print_perf_data() to see the result.
        perf_record = false,
        -- perform callback when loading a persisted breakpoint
        --- @param opts DAPBreakpointOptions options used to create the breakpoint ({condition, logMessage, hitCondition})
        --- @param buf_id integer the buffer the breakpoint was set on
        --- @param line integer the line the breakpoint was set on
        on_load_breakpoint = nil,
        -- set this to true if the breakpoints are not loaded when you are using a session-like plugin.
        always_reload = false,
      }
    end
  }
}
