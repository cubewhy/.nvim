return {
  {
    'stevearc/resession.nvim',
    event = 'BufReadPre', -- Starts session tracking only when an actual file is opened
    keys = {
      {
        '<leader>qs',
        function() require('resession').load(vim.fn.getcwd(), { silence_errors = true }) end,
        desc = 'Restore Directory Session',
      },
      {
        '<leader>qS',
        function() require('resession').select() end,
        desc = 'Select Session',
      },
      {
        '<leader>ql',
        function() require('resession').load('last', { silence_errors = true }) end,
        desc = 'Restore Last Session',
      },
      {
        '<leader>qd',
        function()
          vim.g.resession_disable_save = true
          vim.notify('Session saving disabled for this instance', vim.log.levels.INFO)
        end,
        desc = "Don't Save Current Session",
      },
      { '<leader>qq', '<cmd>qa<cr>', desc = 'Quit all' },
    },
    config = function()
      local resession = require 'resession'
      resession.setup {
        autosave = {
          enabled = false,
          -- How often to save (in seconds)
          interval = 60,
          -- Notify when autosaved
          notify = true,
        },

        options = {
          'binary',
          'bufhidden',
          'buflisted',
          'cmdheight',
          'diff',
          'filetype',
          'modifiable',
          'previewwindow',
          'readonly',
          'scrollbind',
          'winfixheight',
          'winfixwidth',
        },

        -- buf_filter = function(bufnr)
        --   if not vim.api.nvim_buf_is_valid(bufnr) then return false end
        --
        --   local ft = vim.bo[bufnr].filetype
        --   if ft == 'grug-far' or ft:find 'neotest' or ft:find 'dapui' or ft == 'neo-tree' then return false end
        --
        --   local buftype = vim.bo[bufnr].buftype
        --   if buftype == 'terminal' or buftype == 'quickfix' then return false end
        --
        --   if buftype == 'help' then return true end
        --   if buftype ~= '' and buftype ~= 'acwrite' then return false end
        --   if vim.api.nvim_buf_get_name(bufnr) == '' then return false end
        --
        --   return vim.bo[bufnr].buflisted
        -- end,

        buf_filter = require('resession').default_buf_filter,
        tab_buf_filter = function(tabpage, bufnr) return true end,
        load_detail = true,
        load_order = 'modification_time',

        extensions = {
          quickfix = {},
        },
      }

      -- Replicate persistence.nvim's automatic save-on-exit behavior
      vim.api.nvim_create_autocmd('VimLeavePre', {
        callback = function()
          if vim.g.resession_disable_save then return end

          -- Save a session locked specifically to the current working directory
          resession.save(vim.fn.getcwd(), { notify = false })
          -- Save a global backup fallback for the `<leader>ql` keymap
          resession.save('last', { notify = false })
        end,
      })
    end,
  },
}
