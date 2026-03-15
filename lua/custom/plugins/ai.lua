return {
  {
    'olimorris/codecompanion.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-treesitter/nvim-treesitter',
    },
    opts = {
      -- NOTE: The log_level is in `opts.opts`
      opts = {
        log_level = 'DEBUG', -- or 'TRACE'
      },
      interactions = {
        chat = {
          adapter = {
            name = 'ollama',
            model = 'qwen2.5-coder:7b',
          },
        },
        inline = {
          adapter = {
            name = 'ollama',
            model = 'qwen2.5-coder:7b',
          },
        },
      },
    },
  },
}
