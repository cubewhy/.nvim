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
      'mfussenegger/nvim-dap-python',
      'mrcjkb/rustaceanvim',
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
    },
    config = function()
      local dap = require 'dap'
      local dapui = require 'dapui'

      require('telescope').load_extension 'dap'

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
          'debugpy',
        },
      }

      -- keybinding config
      require('which-key').add {
        {
          '<leader>fd',
          group = 'Telescope Debug',
          expand = function()
            local ok, dap = pcall(require, 'dap')
            if not ok or dap.session() == nil then return {} end

            return {
              { 'fdb', function() require('telescope').extensions.dap.list_breakpoints {} end, desc = 'Search Debug Breakpoints' },
              { 'fdf', function() require('telescope').extensions.dap.frames {} end, desc = 'Search Debug Frames' },
              { 'fdv', function() require('telescope').extensions.dap.variables {} end, desc = 'Search Debug Variables' },
            }
          end,
          { '<leader>fdg', function() require('telescope').extensions.dap.configurations {} end, desc = 'Search Debug Configs' },
          { '<leader>fdc', function() require('telescope').extensions.dap.commands {} end, desc = 'Search Debug Commands' },
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
    'nvim-neotest/neotest',
    dependencies = {
      'nvim-neotest/nvim-nio',
      'nvim-lua/plenary.nvim',
      'antlr/antlr4',
      'antoinemadec/FixCursorHold.nvim',
      'nvim-treesitter/nvim-treesitter',
    },
    keys = {
      -- Running Tests
      { '<leader>tr', function() require('neotest').run.run() end, desc = 'Run Nearest' },
      { '<leader>tf', function() require('neotest').run.run(vim.fn.expand '%') end, desc = 'Run File' },
      { '<leader>ts', function() require('neotest').run.run(vim.fn.getcwd()) end, desc = 'Run Suite' },
      { '<leader>tx', function() require('neotest').stop() end, desc = 'Stop' },

      -- UI & Visualization
      { '<leader>tt', function() require('neotest').summary.toggle() end, desc = 'Toggle Summary' },
      { '<leader>to', function() require('neotest').output.open { enter = true, auto_close = true } end, desc = 'Show Output' },
      { '<leader>tO', function() require('neotest').output_panel.toggle() end, desc = 'Toggle Output Panel' },

      -- Debugging & Monitoring
      { '<leader>td', function() require('neotest').run.run { strategy = 'dap' } end, desc = 'Debug Nearest' },
      { '<leader>tw', function() require('neotest').watch.toggle(vim.fn.expand '%') end, desc = 'Watch File' },

      -- Navigation
      { '[n', function() require('neotest').jump.prev { status = 'failed' } end, desc = 'Prev Failed Test' },
      { ']n', function() require('neotest').jump.next { status = 'failed' } end, desc = 'Next Failed Test' },
    },
    opts = {
      status = { virtual_text = true },
      output = { open_on_run = true },
      -- Add your adapters here
      adapters = {},
    },
  },
  {
    'Weissle/persistent-breakpoints.nvim',
    event = 'BufReadPost',
    keys = {
      { '<leader>db', function() require('persistent-breakpoints.api').toggle_breakpoint() end, desc = 'Toggle Breakpoint' },
      { '<leader>dB', function() require('persistent-breakpoints.api').set_conditional_breakpoint() end, desc = 'Conditional Breakpoint' },
      { '<leader>dc', function() require('persistent-breakpoints.api').clear_all_breakpoints() end, desc = 'Clear Breakpoints' },
      { '<leader>dl', function() require('persistent-breakpoints.api').set_log_point() end, desc = 'Set Log Point' },
    },
    config = function()
      require('persistent-breakpoints').setup {
        save_dir = vim.fn.stdpath 'data' .. '/nvim_checkpoints',
        -- when to load the breakpoints? "BufReadPost" is recommanded.
        load_breakpoints_event = { 'BufReadPost' },
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
    end,
  },
  {
    'theHamsta/nvim-dap-virtual-text',
    event = 'VeryLazy',
    dependencies = {
      'mfussenegger/nvim-dap',
      'nvim-treesitter/nvim-treesitter',
    },
    config = function()
      require('nvim-dap-virtual-text').setup {
        enabled = true, -- enable this plugin (the default)
        enabled_commands = true, -- create commands DapVirtualTextEnable, DapVirtualTextDisable, DapVirtualTextToggle, (DapVirtualTextForceRefresh for refreshing when debug adapter did not notify its termination)
        highlight_changed_variables = true, -- highlight changed values with NvimDapVirtualTextChanged, else always NvimDapVirtualText
        highlight_new_as_changed = false, -- highlight new variables in the same way as changed variables (if highlight_changed_variables)
        show_stop_reason = true, -- show stop reason when stopped for exceptions
        commented = false, -- prefix virtual text with comment string
        only_first_definition = true, -- only show virtual text at first definition (if there are multiple)
        all_references = false, -- show virtual text on all all references of the variable (not only definitions)
        clear_on_continue = false, -- clear virtual text on "continue" (might cause flickering when stepping)
        --- A callback that determines how a variable is displayed or whether it should be omitted
        --- @param variable Variable https://microsoft.github.io/debug-adapter-protocol/specification#Types_Variable
        --- @param buf number
        --- @param stackframe dap.StackFrame https://microsoft.github.io/debug-adapter-protocol/specification#Types_StackFrame
        --- @param node userdata tree-sitter node identified as variable definition of reference (see `:h tsnode`)
        --- @param options nvim_dap_virtual_text_options Current options for nvim-dap-virtual-text
        --- @return string|nil A text how the virtual text should be displayed or nil, if this variable shouldn't be displayed
        display_callback = function(variable, buf, stackframe, node, options)
          -- by default, strip out new line characters
          if options.virt_text_pos == 'inline' then
            return ' = ' .. variable.value:gsub('%s+', ' ')
          else
            return variable.name .. ' = ' .. variable.value:gsub('%s+', ' ')
          end
        end,
        -- position of virtual text, see `:h nvim_buf_set_extmark()`, default tries to inline the virtual text. Use 'eol' to set to end of line
        virt_text_pos = vim.fn.has 'nvim-0.10' == 1 and 'inline' or 'eol',

        -- experimental features:
        all_frames = false, -- show virtual text for all stack frames not only current. Only works for debugpy on my machine.
        virt_lines = false, -- show virtual lines instead of virtual text (will flicker!)
        virt_text_win_col = nil, -- position the virtual text at a fixed window column (starting from the first text column) ,
        -- e.g. 80 to position at column 80, see `:h nvim_buf_set_extmark()`
      }
    end,
  },
}
