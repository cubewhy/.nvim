return {
  'folke/todo-comments.nvim',
  dependencies = { 'nvim-lua/plenary.nvim' },
  opts = {
    highlight = {
      multiline = true,
    },
  },
  keys = {
    {
      '<leader>st',
      '<cmd>TodoTelescope<cr>',
      desc = 'Todo (Telescope)',
    },
    {
      '<leader>sT',
      '<cmd>TodoTelescope keywords=TODO,FIXME<cr>',
      desc = 'Todo/Fixme (Telescope)',
    },
    {
      ']t',
      function() require('todo-comments').jump_next() end,
      desc = 'Next Todo Comment',
    },
    {
      '[t',
      function() require('todo-comments').jump_prev() end,
      desc = 'Previous Todo Comment',
    },
  },
}
