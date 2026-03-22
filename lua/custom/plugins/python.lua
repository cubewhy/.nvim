return {
  {
    'linux-cultist/venv-selector.nvim',
    dependencies = {
      { 'nvim-telescope/telescope.nvim', version = '*', dependencies = { 'nvim-lua/plenary.nvim' } }, -- optional: you can also use fzf-lua, snacks, mini-pick instead.
    },
    ft = 'python', -- Load when opening Python files
    keys = { { '<leader>cv', '<cmd>VenvSelect<cr>', desc = 'Select venv' } }, -- Open picker on keymap
    opts = {
      options = {
        override_notify = false,
      },
      search = {}, -- custom search definitions
    },
  },
  {
    'Vimjas/vim-python-pep8-indent',
  },
}
