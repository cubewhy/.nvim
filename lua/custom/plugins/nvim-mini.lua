return {
  'nvim-mini/mini.nvim',
  version = false,
  keys = {
    {
      '<leader>bd',
      function() require('mini.bufremove').delete(0, false) end,
      desc = 'Delete Buffer',
    },
    {
      '<leader>bo',
      function()
        local current = vim.api.nvim_get_current_buf()
        local bufs = vim.api.nvim_list_bufs()
        for _, buf in ipairs(bufs) do
          if vim.api.nvim_buf_is_valid(buf) and vim.bo[buf].buflisted and buf ~= current then require('mini.bufremove').delete(buf, false) end
        end
      end,
      desc = 'Close Other Buffers',
    },
  },
  init = function()
    vim.api.nvim_create_autocmd('BufHidden', {
      desc = 'Wipe empty, unmodified buffers when they are hidden',
      callback = function(event)
        local buf = event.buf

        if not vim.api.nvim_buf_is_valid(buf) then return end

        local name = vim.api.nvim_buf_get_name(buf)
        local is_modified = vim.bo[buf].modified
        local buftype = vim.bo[buf].buftype
        local filetype = vim.bo[buf].filetype
        local line_count = vim.api.nvim_buf_line_count(buf)
        local first_line = vim.api.nvim_buf_get_lines(buf, 0, 1, false)[1]

        if name == '' and not is_modified and buftype == '' and filetype == '' and line_count == 1 and first_line == '' then
          vim.schedule(function()
            if vim.api.nvim_buf_is_valid(buf) then vim.api.nvim_buf_delete(buf, { force = true }) end
          end)
        end
      end,
    })
  end,
  config = function()
    require('mini.bufremove').setup {}

    require('mini.move').setup {
      mappings = {
        left = '<M-h>',
        right = '<M-l>',
        down = '<M-j>',
        up = '<M-k>',

        line_left = '<M-h>',
        line_right = '<M-l>',
        line_down = '<M-j>',
        line_up = '<M-k>',
      },
    }

    -- Better Around/Inside textobjects
    --
    -- Examples:
    --  - va)  - [V]isually select [A]round [)]paren
    --  - yinq - [Y]ank [I]nside [N]ext [Q]uote
    --  - ci'  - [C]hange [I]nside [']quote
    local ai = require 'mini.ai'
    ai.setup {
      custom_textobjects = {
        f = ai.gen_spec.treesitter {
          a = '@function.outer',
          i = '@function.inner',
        },

        c = ai.gen_spec.treesitter {
          a = '@class.outer',
          i = '@class.inner',
        },

        o = ai.gen_spec.treesitter {
          a = { '@conditional.outer', '@loop.outer' },
          i = { '@conditional.inner', '@loop.inner' },
        },
      },
      n_lines = 500,
    }
  end,
}
