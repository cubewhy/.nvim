return {
  'monaqa/dial.nvim',
  keys = {
    { '<C-a>', function() return require('dial.map').inc_normal() end, expr = true, desc = 'Increment' },
    { '<C-x>', function() return require('dial.map').dec_normal() end, expr = true, desc = 'Decrement' },
  },
  config = function()
    local augend = require 'dial.augend'
    require('dial.config').augends:setup {
      default = {
        augend.integer.alias.decimal,
        augend.constant.alias.bool,
        augend.semver.alias.semver,
        augend.constant.new {
          elements = { 'and', 'or' },
          word = true,
          cyclic = true,
        },
      },
    }
  end,
}
