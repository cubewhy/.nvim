return {
  { -- Add indentation guides even on blank lines
    'lukas-reineke/indent-blankline.nvim',
    -- Enable `lukas-reineke/indent-blankline.nvim`
    -- See `:help ibl`
    main = 'ibl',
    event = 'VeryLazy',
    opts = {
      indent = {
        -- char = '┋',
      },
      exclude = {
        filetypes = {
          'dashboard',
          'neo-tree',
          'help',
          'lazy',
          'mason',
          'notify',
          'toggleterm',
          'trouble',
        },
        buftypes = {
          'terminal',
          'nofile',
        },
      },
      scope = { enabled = false },
    },
  },
}
