return {
  {
    'goolord/alpha-nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      local alpha = require 'alpha'
      local startify = require 'alpha.themes.startify'

      startify.section.top_buttons.val = {
        startify.button('n', '󰈔 New File', '<cmd>enew<CR>'),
        startify.button('s', ' Restore Session', '<cmd>lua require("persistence").load()<CR>'),
        startify.button('l', '󰒲 Lazy', '<cmd>Lazy<CR>'),
        startify.button('u', '󰊳 Update', '<cmd>Lazy update<CR>'),
        startify.button('q', ' Quit', '<cmd>qa<CR>'),
      }

      startify.file_icons.provider = 'devicons'

      alpha.setup(startify.config)
    end,
  },
}
