return {
  'folke/todo-comments.nvim',
  event = 'BufEnter',
  keys = {
    { '<leader>st', function() Snacks.picker.todo_comments() end, desc = 'Todo' },
    { '<leader>sT', function() Snacks.picker.todo_comments { keywords = { 'TODO', 'FIX', 'FIXME' } } end, desc = 'Todo/Fix/Fixme' },
  },
  opts = {},
  config = function(_, opts)
    require('todo-comments').setup(opts)

    vim.keymap.set('n', ']t', function() require('todo-comments').jump_next() end, { desc = 'Next todo comment' })
    vim.keymap.set('n', '[t', function() require('todo-comments').jump_prev() end, { desc = 'Previous todo comment' })
  end,
}
