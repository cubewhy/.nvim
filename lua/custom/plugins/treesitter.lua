return {
  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    event = { 'BufReadPost', 'BufNewFile' },
    config = function()
      require('nvim-treesitter').install {
        'bash',
        'c',
        'diff',
        'html',
        'lua',
        'luadoc',
        'markdown',
        'markdown_inline',
        'query',
        'vim',
        'vimdoc',
        'python',
      }

      vim.api.nvim_create_autocmd('FileType', {
        callback = function(args)
          local bufnr = args.buf
          local lang = vim.treesitter.language.get_lang(vim.bo[bufnr].filetype)
          if lang then pcall(vim.treesitter.start, bufnr, lang) end
        end,
      })
    end,
  },
  {
    'nvim-treesitter/nvim-treesitter-context',
    event = 'BufReadPost',
    config = function()
      require('treesitter-context').setup {
        enable = true, -- Enable this plugin (Can be enabled/disabled later via commands)
        multiwindow = false, -- Enable multiwindow support.
        max_lines = 3, -- How many lines the window should span. Values <= 0 mean no limit.
        min_window_height = 0, -- Minimum editor window height to enable context. Values <= 0 mean no limit.
        line_numbers = true,
        multiline_threshold = 20, -- Maximum number of lines to show for a single context
        trim_scope = 'outer', -- Which context lines to discard if `max_lines` is exceeded. Choices: 'inner', 'outer'
        mode = 'cursor', -- Line used to calculate context. Choices: 'cursor', 'topline'
        -- Separator between context and content. Should be a single character string, like '-'.
        -- When separator is set, the context will only show up when there are at least 2 lines above cursorline.
        separator = nil,
        zindex = 20, -- The Z-index of the context window
        on_attach = nil, -- (fun(buf: integer): boolean) return false to disable attaching
      }
    end,
  },
  {
    'nvim-treesitter/nvim-treesitter-textobjects',
    branch = 'main',
    event = 'BufEnter',
    init = function()
      -- Disable entire built-in ftplugin mappings to avoid conflicts.
      -- See https://github.com/neovim/neovim/tree/master/runtime/ftplugin for built-in ftplugins.
      vim.g.no_plugin_maps = true

      -- Or, disable per filetype (add as you like)
      -- vim.g.no_python_maps = true
      -- vim.g.no_ruby_maps = true
      -- vim.g.no_rust_maps = true
      -- vim.g.no_go_maps = true
    end,
    keys = {
      {
        ']f',
        function() require('nvim-treesitter-textobjects.move').goto_next_start('@function.outer', 'textobjects') end,
        mode = { 'n', 'x', 'o' },
        desc = 'Next function start',
      },
      {
        '[f',
        function() require('nvim-treesitter-textobjects.move').goto_previous_start('@function.outer', 'textobjects') end,
        mode = { 'n', 'x', 'o' },
        desc = 'Prev function start',
      },
      {
        ']F',
        function() require('nvim-treesitter-textobjects.move').goto_next_end('@function.outer', 'textobjects') end,
        mode = { 'n', 'x', 'o' },
        desc = 'Next function end',
      },
      {
        '[F',
        function() require('nvim-treesitter-textobjects.move').goto_previous_end('@function.outer', 'textobjects') end,
        mode = { 'n', 'x', 'o' },
        desc = 'Prev function end',
      },

      {
        ']]',
        function() require('nvim-treesitter-textobjects.move').goto_next_start('@class.outer', 'textobjects') end,
        mode = { 'n', 'x', 'o' },
        desc = 'Next class start',
      },
      {
        '[[',
        function() require('nvim-treesitter-textobjects.move').goto_previous_start('@class.outer', 'textobjects') end,
        mode = { 'n', 'x', 'o' },
        desc = 'Prev class start',
      },
      {
        '][',
        function() require('nvim-treesitter-textobjects.move').goto_next_end('@class.outer', 'textobjects') end,
        mode = { 'n', 'x', 'o' },
        desc = 'Next class end',
      },
      {
        '[]',
        function() require('nvim-treesitter-textobjects.move').goto_previous_end('@class.outer', 'textobjects') end,
        mode = { 'n', 'x', 'o' },
        desc = 'Prev class end',
      },

      {
        ']o',
        function() require('nvim-treesitter-textobjects.move').goto_next_start({ '@loop.inner', '@loop.outer' }, 'textobjects') end,
        mode = { 'n', 'x', 'o' },
        desc = 'Next loop',
      },
      {
        ']s',
        function() require('nvim-treesitter-textobjects.move').goto_next_start('@local.scope', 'locals') end,
        mode = { 'n', 'x', 'o' },
        desc = 'Next scope',
      },
      { ']z', function() require('nvim-treesitter-textobjects.move').goto_next_start('@fold', 'folds') end, mode = { 'n', 'x', 'o' }, desc = 'Next fold' },

      {
        ']d',
        function() require('nvim-treesitter-textobjects.move').goto_next('@conditional.outer', 'textobjects') end,
        mode = { 'n', 'x', 'o' },
        desc = 'Next conditional',
      },
      {
        '[d',
        function() require('nvim-treesitter-textobjects.move').goto_previous('@conditional.outer', 'textobjects') end,
        mode = { 'n', 'x', 'o' },
        desc = 'Prev conditional',
      },

      { '<leader>a', function() require('nvim-treesitter-textobjects.swap').swap_next '@parameter.inner' end, desc = 'Swap next parameter' },
      { '<leader>A', function() require('nvim-treesitter-textobjects.swap').swap_previous '@parameter.outer' end, desc = 'Swap prev parameter' },
    },
  },
}
