return {
  {
    'stevearc/oil.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    lazy = false,
    keys = {
      { '\\', function() require('oil').toggle_float() end, desc = 'Oil Float' },
      { '-', function() require('oil').open() end, desc = 'Oil' },
    },
    opts = {
      default_file_explorer = true,
      win_options = {
        winblend = 10,
      },
      float = {
        padding = 2,
        max_width = 80,
        max_height = 20,
        border = 'rounded',
      },
      view_options = {
        show_hidden = false,
        is_hidden_file = function(name, bufnr)
          local ignored = { 'node_modules', '.direnv', '.git' }
          for _, pattern in ipairs(ignored) do
            if name == pattern then return true end
          end
          return false
        end,
      },
      columns = {
        'icon',
        -- 'permissions',
        -- 'size',
        -- 'mtime',
      },
      skip_confirm_for_simple_edits = true,
      keymaps = {
        ['g?'] = 'show_help',
        ['<CR>'] = 'actions.select',
        ['<C-s>'] = { 'actions.select', opts = { vertical = true } },
        ['<C-h>'] = { 'actions.select', opts = { horizontal = true } },
        ['<C-t>'] = { 'actions.select', opts = { tab = true } },
        ['<C-p>'] = 'actions.preview',
        ['<C-c>'] = 'actions.close',
        ['<C-l>'] = 'actions.refresh',
        ['-'] = 'actions.parent',
        ['_'] = 'actions.open_cwd',
        ['`'] = { 'actions.cd', mode = 'n' },
        ['g~'] = { 'actions.cd', opts = { scope = 'tab' }, mode = 'n' },
        ['gs'] = 'actions.change_sort',
        ['gx'] = 'actions.open_external',
        ['g.'] = 'actions.toggle_hidden',
      },
    },
  },
  {
    'antosha417/nvim-lsp-file-operations',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'stevearc/oil.nvim',
    },
    config = function() require('lsp-file-operations').setup() end,
  },
}
