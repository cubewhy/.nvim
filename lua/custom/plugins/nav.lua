return {
  {
    'folke/snacks.nvim',
    keys = {
      {
        '<M-n>',
        function() Snacks.words.jump(vim.v.count1, true) end,
        desc = 'Next Reference',
        mode = { 'n', 't' },
      },
      {
        '<M-p>',
        function() Snacks.words.jump(-vim.v.count1, true) end,
        desc = 'Prev Reference',
        mode = { 'n', 't' },
      },
    },
    ---@type snacks.Config
    opts = {
      words = {},
    },
  },
}
