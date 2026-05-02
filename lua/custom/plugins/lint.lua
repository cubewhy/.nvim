return {
  {
    'nvimtools/none-ls.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' },
    event = { 'BufReadPre', 'BufNewFile' },
    config = function()
      local null_ls = require 'null-ls'
      -- local helpers = require 'null-ls.helpers'

      null_ls.setup {
        sources = {
          null_ls.builtins.diagnostics.markdownlint_cli2,
          null_ls.builtins.diagnostics.golangci_lint,
        },
      }
    end,
  },
}
