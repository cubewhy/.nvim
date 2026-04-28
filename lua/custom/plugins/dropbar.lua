return {
  {
    'cubewhy/dropbar.nvim',
    branch = 'fix-event',
    dependencies = {
      'nvim-telescope/telescope-fzf-native.nvim',
      build = 'make',
    },
    opts = {},
    config = function(_, opts)
      require('dropbar').setup(opts)
      local dropbar_api = require 'dropbar.api'
      vim.keymap.set('n', '<leader>;', dropbar_api.pick, { desc = 'Pick symbols in winbar' })
      vim.keymap.set('n', '[;', dropbar_api.goto_context_start, { desc = 'Go to start of current context' })
      vim.keymap.set('n', '];', dropbar_api.select_next_context, { desc = 'Select next context' })
    end,
  },
}
