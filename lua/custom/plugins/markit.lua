return {
  {
    '2kabhishek/markit.nvim',
    dependencies = {
      {
        '2kabhishek/pickme.nvim',
        dependencies = {
          'nvim-telescope/telescope.nvim',
        },
        config = function()
          require('pickme').setup {
            provider = 'telescope',
            add_default_keybindings = false,
          }
        end,
      },
      'nvim-lua/plenary.nvim',
    },
    opts = {
      -- whether to add comprehensive default keybindings. default true
      add_default_keybindings = false,
      -- which builtin marks to show. default {}
      builtin_marks = { '.', '<', '>', '^' },
      -- whether movements cycle back to the beginning/end of buffer. default true
      cyclic = true,
      -- whether the shada file is updated after modifying uppercase marks. default false
      force_write_shada = false,
      -- how often (in ms) to redraw signs/recompute mark positions.
      -- higher value means better performance but may cause visual lag,
      -- while lower value may cause performance penalties. default 150.
      refresh_interval = 150,
      -- sign priorities for each type of mark - builtin marks, uppercase marks, lowercase
      -- marks, and bookmarks.
      -- can be either a table with all/none of the keys, or a single number, in which case
      -- the priority applies to all marks.
      -- default 10.
      sign_priority = { lower = 10, upper = 15, builtin = 8, bookmark = 20 },
      -- disables mark tracking for specific filetypes. default {}
      excluded_filetypes = {},
      -- disables mark tracking for specific buftypes. default {}
      excluded_buftypes = {},
      -- whether to enable the bookmark system. when disabled, improves startup performance, default true
      enable_bookmarks = true,
      -- bookmark groups configuration (only used when enable_bookmarks = true)
      bookmarks = {
        {
          sign = '⚑', -- string: sign character to display (empty string to disable)
          virt_text = 'hello', -- string: virtual text to show at end of line
          annotate = false, -- boolean: whether to prompt for annotation when setting bookmark
        },
        { sign = '!', virt_text = '', annotate = false },
        { sign = '@', virt_text = '', annotate = true },
      },
    },
    event = { 'BufReadPre', 'BufNewFile' },
    config = function(_, opts)
      require('markit').setup(opts)

      local wk = require 'which-key'

      wk.add {
        { '<leader>m', group = 'Marks', icon = { icon = '⚑', color = 'orange' } },

        { '<leader>mm', '<cmd>Markit mark list all<cr>', desc = 'List All Marks' },
        { '<leader>mM', '<cmd>Markit mark list buffer<cr>', desc = 'List Buffer Marks' },
        { '<leader>ms', '<cmd>Markit mark set<cr>', desc = 'Set Next Available Mark' },
        { '<leader>mS', '<cmd>Markit mark set<cr>', desc = 'Set Mark (Interactive)' },
        { '<leader>mt', '<cmd>Markit mark toggle<cr>', desc = 'Toggle Mark at Cursor' },
        { '<leader>mT', '<cmd>Markit mark toggle<cr>', desc = 'Toggle Mark (Interactive)' },
        { '<leader>mj', '<cmd>Markit mark next<cr>', desc = 'Next Mark' },
        { '<leader>mk', '<cmd>Markit mark prev<cr>', desc = 'Previous Mark' },
        { '<leader>mP', '<cmd>Markit mark preview<cr>', desc = 'Preview Mark' },
        { '<leader>md', '<cmd>Markit mark delete line<cr>', desc = 'Delete Marks in Line' },
        { '<leader>mD', '<cmd>Markit mark delete buffer<cr>', desc = 'Delete Marks in Buffer' },
        { '<leader>mX', '<cmd>Markit mark delete<cr>', desc = 'Delete Mark (Interactive)' },

        { '<leader>mb', '<cmd>Markit bookmark list all<cr>', desc = 'List All Bookmarks' },
        { '<leader>mx', '<cmd>Markit bookmark delete<cr>', desc = 'Delete Bookmark at Cursor' },
        { '<leader>ma', '<cmd>Markit bookmark annotate<cr>', desc = 'Annotate Bookmark' },
        { '<leader>ml', '<cmd>Markit bookmark next<cr>', desc = 'Next Bookmark' },
        { '<leader>mh', '<cmd>Markit bookmark prev<cr>', desc = 'Previous Bookmark' },
        { '<leader>mv', '<cmd>Markit bookmark signs<cr>', desc = 'Toggle Bookmark Signs' },

        { '<leader>mq', group = 'Export to Quickfix' },
        { '<leader>mqm', '<cmd>Markit mark list quickfix all<cr>', desc = 'All Marks -> Quickfix' },
        { '<leader>mqb', '<cmd>Markit bookmark list quickfix all<cr>', desc = 'All Bookmarks -> Quickfix' },
        { '<leader>mqM', '<cmd>Markit mark list quickfix buffer<cr>', desc = 'Buffer Marks -> Quickfix' },
        { '<leader>mqg', '<cmd>Markit mark list quickfix all<cr>', desc = 'Global Marks -> Quickfix' },

        { '<leader>mn', group = 'Next Group Bookmark' },
        { '<leader>mp', group = 'Prev Group Bookmark' },
        { '<leader>mc', group = 'Delete Group Bookmarks' },
        { '<leader>mg', group = 'List Group Bookmarks' },
      }

      for i = 0, 2 do
        wk.add {
          { '<leader>m' .. i, '<cmd>Markit bookmark toggle ' .. i .. '<cr>', desc = 'Toggle Group ' .. i .. ' Bookmark' },
          { '<leader>mn' .. i, '<cmd>Markit bookmark next ' .. i .. '<cr>', desc = 'Next Group ' .. i .. ' Bookmark' },
          { '<leader>mp' .. i, '<cmd>Markit bookmark prev ' .. i .. '<cr>', desc = 'Prev Group ' .. i .. ' Bookmark' },
          { '<leader>mc' .. i, '<cmd>Markit bookmark delete ' .. i .. '<cr>', desc = 'Delete Group ' .. i .. ' Bookmarks' },
          { '<leader>mg' .. i, '<cmd>Markit bookmark list ' .. i .. '<cr>', desc = 'List Group ' .. i .. ' Bookmarks' },
          { '<leader>mq' .. i, '<cmd>Markit bookmark list quickfix ' .. i .. '<cr>', desc = 'Group ' .. i .. ' -> Quickfix' },
        }
      end
    end,
  },
}
