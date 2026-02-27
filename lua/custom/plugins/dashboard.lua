return {
  'nvimdev/dashboard-nvim',
  event = 'VimEnter',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  opts = function()
    local logo = [[
    NVIM
    ]]
    logo = string.rep('\n', 4) .. logo .. '\n\n'

    local opts = {
      theme = 'hyper',
      config = {
        header = vim.split(logo, '\n'),
        shortcut = {
          { desc = '󰊳 Update', group = '@property', action = 'Lazy update', key = 'u' },
          {
            icon = ' ',
            icon_hl = '@variable',
            desc = 'Restore Session',
            group = 'Label',
            action = 'lua require("persistence").load()',
            key = 's',
          },
          {
            icon = '󰈔 ',
            desc = 'New File',
            group = 'DiagnosticHint',
            action = 'enew',
            key = 'n',
          },
          {
            icon = '󰒲 ',
            desc = 'Lazy',
            group = 'DiagnosticOK',
            action = 'Lazy',
            key = 'l',
          },
          {
            icon = ' ',
            desc = 'Quit',
            group = 'DiagnosticError',
            action = 'qa',
            key = 'q',
          },
        },
      },
    }
    return opts
  end,
}
