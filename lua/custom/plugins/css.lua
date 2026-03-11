return {
  {
    'catgoose/nvim-colorizer.lua',
    event = 'BufReadPre',
    opts = {
      options = {
        parsers = {
          css = true,
          tailwind = { enable = false, lsp = true },
        }
      },
    },
  },
}
