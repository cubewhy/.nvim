-- Neo-tree is a Neovim plugin to browse the file system
-- https://github.com/nvim-neo-tree/neo-tree.nvim

return {
  {
    'nvim-neo-tree/neo-tree.nvim',
    lazy = true,
    cmd = 'Neotree',
    version = '*',
    dependencies = {
      'nvim-lua/plenary.nvim',
      { 'nvim-tree/nvim-web-devicons' },
      'MunifTanjim/nui.nvim',
    },
    keys = {
      { '\\', ':Neotree reveal<CR>', desc = 'NeoTree reveal', silent = true },
      { '<leader>e', ':Neotree toggle<CR>', desc = 'Toggle NeoTr[e]e', silent = true }, -- lazyvim compat
    },
    opts = {
      filesystem = {
        use_libuv_file_watcher = true,
        async_directory_scan = 'auto',
        bind_to_cwd = true,
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
    lazy = true,
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-neo-tree/neo-tree.nvim',
    },
    config = function() require('lsp-file-operations').setup() end,
  },
}
