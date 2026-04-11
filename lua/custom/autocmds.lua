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
    'dap-float',
    'oil',
    'lazygit',
    'neotest-summary',
  },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.keymap.set('n', 'q', '<cmd>close<cr>', { buffer = event.buf, silent = true, desc = 'Quit window' })
  end,
})

if vim.g.neovide then
  -- auto toggle ime
  vim.g.neovide_input_ime = false
  local function set_ime(args)
    if args.event:match 'Enter$' then
      vim.g.neovide_input_ime = true
    else
      vim.g.neovide_input_ime = false
    end
  end

  local ime_input = vim.api.nvim_create_augroup('ime_input', { clear = true })

  vim.api.nvim_create_autocmd({ 'InsertEnter', 'InsertLeave' }, {
    group = ime_input,
    pattern = '*',
    callback = set_ime,
  })

  vim.api.nvim_create_autocmd({ 'CmdlineEnter', 'CmdlineLeave' }, {
    group = ime_input,
    -- pattern = '[/\\?]',
    pattern = '*',
    callback = set_ime,
  })

  vim.api.nvim_create_autocmd({ 'TermEnter', 'TermLeave' }, {
    group = ime_input,
    pattern = '*',
    callback = set_ime,
  })
end

vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'gitsendemail', 'conf', 'editorconfig', 'qf', 'checkhealth', 'less' },
  callback = function(event) vim.bo[event.buf].syntax = vim.bo[event.buf].filetype end,
})

require 'custom.indent'
