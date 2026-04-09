return {
  {
    'catgoose/nvim-colorizer.lua',
    event = 'BufReadPre',
    config = function()
      require('colorizer').setup {
        filetypes = { 'css', 'sass', 'scss' },
        buftypes = {},
        user_commands = true,
        lazy_load = true,
        options = {
          parsers = {
            css = true,
            css_fn = true,
          },
          css_var_rgb = { enable = true }, -- CSS vars with R,G,B (e.g. --color: 240,198,198)
          css_var = {
            enable = true, -- resolve var(--name) references to their defined color
            parsers = { css = true }, -- parsers for resolving variable values
          },
        },
      }

      require('colorizer').setup {
        filetypes = { 'sass' },
        buftypes = {},
        user_commands = true,
        lazy_load = true,
        options = {
          sass = {
            enable = true, -- parse Sass color variables
            parsers = { css = true }, -- parsers for resolving variable values
            variable_pattern = '^%$([%w_-]+)', -- Lua pattern for variable names
          },
        },
      }

      -- We use tailwind ls instead
      -- require('colorizer').setup {
      --   filetypes = { 'html', "typescriptreact", 'javascriptreact' },
      --   buftypes = {},
      --   user_commands = true,
      --   lazy_load = true,
      --   options = {
      --     parsers = {
      --     },
      --   },
      -- }
    end,
  },
}
