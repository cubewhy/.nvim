-- Neo-tree is a Neovim plugin to browse the file system
-- https://github.com/nvim-neo-tree/neo-tree.nvim

return {
  {
    'nvim-neo-tree/neo-tree.nvim',
    version = '*',
    dependencies = {
      'nvim-lua/plenary.nvim',
      { 'nvim-tree/nvim-web-devicons' },
      'MunifTanjim/nui.nvim',
    },
    lazy = false,
    keys = {
      { '\\', ':Neotree reveal<CR>', desc = 'NeoTree reveal', silent = true },
      { '<leader>e', ':Neotree toggle<CR>', desc = 'Toggle NeoTr[e]e', silent = true }, -- lazyvim compat
    },
    opts = {
      filesystem = {
        window = {
          mappings = {
            ['\\'] = 'close_window',
            ['<leader>e'] = 'close_window',
          },
        },
        follow_current_file = {
          enabled = true,
          leave_dirs_open = false,
        },
      },
    },
  },
  {
    'antosha417/nvim-lsp-file-operations',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-neo-tree/neo-tree.nvim',
    },
    config = function() require('lsp-file-operations').setup() end,
  },
}
