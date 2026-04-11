local indent_settings = vim.api.nvim_create_augroup('IndentSettings', { clear = true })

local function set_indent(size)
  vim.opt_local.expandtab = true
  vim.opt_local.shiftwidth = size
  vim.opt_local.tabstop = size
  vim.opt_local.softtabstop = size
end

vim.api.nvim_create_autocmd('FileType', {
  group = indent_settings,
  pattern = { 'json', 'yaml', 'javascript', 'typescript', 'javascriptreact', 'typescriptreact', 'html', 'css' },
  callback = function() set_indent(2) end,
})

vim.api.nvim_create_autocmd('FileType', {
  group = indent_settings,
  pattern = { 'python', 'rust', 'lua' },
  callback = function() set_indent(4) end,
})

vim.api.nvim_create_autocmd('FileType', {
  pattern = 'go',
  callback = function()
    vim.opt_local.expandtab = false
    vim.opt_local.shiftwidth = 4
    vim.opt_local.tabstop = 4
  end,
})

vim.api.nvim_create_autocmd('FileType', {
  pattern = 'make',
  callback = function()
    vim.opt_local.expandtab = false
    vim.opt_local.shiftwidth = 8
    vim.opt_local.tabstop = 8
  end,
})
