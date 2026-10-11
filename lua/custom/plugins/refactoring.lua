return {
  {
    'smjonas/inc-rename.nvim',
    event = 'BufEnter',
    config = function()
      require('inc_rename').setup {
        -- the name of the command
        cmd_name = 'IncRename',
        -- the highlight group used for highlighting the identifier's new name
        hl_group = 'Substitute',
        -- whether an empty new name should be previewed; if false the command preview will be cancelled instead
        preview_empty_name = false,
        -- whether to display a `Renamed m instances in n files` message after a rename operation
        show_message = true,
        -- whether to save the "IncRename" command in the commandline history (set to false to prevent issues with
        -- navigating to older entries that may arise due to the behavior of command preview)
        save_in_cmdline_history = true,
        -- the type of the external input buffer to use (currently supports "dressing" or "snacks")
        input_buffer_type = nil,
        -- callback to run after renaming, receives the result table (from LSP handler) as an argument
        post_hook = nil,
      }

      require('noice').setup {
        presets = { inc_rename = true },
      }
    end,
  },
  {
    'ThePrimeagen/refactoring.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-treesitter/nvim-treesitter',
    },
    keys = {
      { '<leader>re', ':Refactor extract ', mode = 'x', desc = 'Extract Function' },
      { '<leader>rf', ':Refactor extract_to_file ', mode = 'x', desc = 'Extract to File' },
      { '<leader>rv', ':Refactor extract_var ', mode = 'x', desc = 'Extract Variable' },

      { '<leader>ri', '<cmd>Refactor inline_var<cr>', mode = { 'n', 'x' }, desc = 'Inline Variable' },

      { '<leader>rI', '<cmd>Refactor inline_func<cr>', mode = 'n', desc = 'Inline Function' },
      { '<leader>rb', ':Refactor extract_block', mode = 'n', desc = 'Extract Block' },
      { '<leader>rbf', ':Refactor extract_block_to_file', mode = 'n', desc = 'Extract Block to File' },
    },
    opts = {},
  },
}
