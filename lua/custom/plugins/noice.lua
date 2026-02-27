return {
  {
    'rcarriga/nvim-notify',
    opts = {
      timeout = 1500,
      render = 'compact',
      stages = 'static',
    },
  },
  {
    'folke/noice.nvim',
    event = 'VeryLazy',
    keys = {
      {
        '<leader>un',
        function() require('notify').dismiss { silent = true, pending = true } end,
        desc = 'Dismiss All Notifications',
      },
      {
        '<leader>nh',
        '<cmd>Noice telescope<cr>',
        desc = 'Noice History',
      },
      {
        '<leader>nl',
        '<cmd>Noice last<cr>',
        desc = 'Noice Last Message',
      },
    },
    opts = {
      notify = {
        enabled = true,
        view = 'notify',
      },
      cmdline = {
        view = 'cmdline',
        format = {
          search_down = { kind = 'search', pattern = '^/', icon = ' ', lang = 'regex', view = 'cmdline' },
          search_up = { kind = 'search', pattern = '^%?', icon = ' ', lang = 'regex', view = 'cmdline' },
          cmdline = { pattern = '^:', icon = '', lang = 'vim', view = 'cmdline_popup' },
        },
      },
      views = {
        cmdline_popup = {
          position = {
            row = '15%',
            col = '50%',
          },
          size = {
            width = 60,
            height = 'auto',
          },
        },
        cmdline = {
          backend = 'popup',
          relative = 'editor',
          position = {
            row = '100%',
            col = 0,
          },
          size = {
            width = '100%',
            height = 'auto',
          },
          border = {
            style = 'none',
          },
        },
      },
      routes = {
        {
          filter = { event = 'msg_show', kind = 'search_count' },
          opts = { skip = true },
        },
      },
    },
    dependencies = {
      -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
      'MunifTanjim/nui.nvim',
      -- OPTIONAL:
      --   `nvim-notify` is only needed, if you want to use the notification view.
      --   If not available, we use `mini` as the fallback
      'rcarriga/nvim-notify',
    },
  },
}
