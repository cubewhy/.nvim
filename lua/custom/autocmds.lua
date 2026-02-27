-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`

vim.api.nvim_create_autocmd('FileType', {
  group = vim.api.nvim_create_augroup('close_with_q', { clear = true }),
  pattern = {
    'help',
    'lspinfo',
    'checkhealth',
    'man',
    'qf',
    'query',
    'grug-far',
    'grug-far-help',
    'notify',
  },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.keymap.set('n', 'q', '<cmd>close<cr>', { buffer = event.buf, silent = true, desc = 'Quit window' })
  end,
})
