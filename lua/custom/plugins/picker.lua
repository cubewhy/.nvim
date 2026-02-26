return {
  {
    'nvim-telescope/telescope.nvim',
    event = 'VimEnter',
    dependencies = {
      'nvim-lua/plenary.nvim',
      {
        'nvim-telescope/telescope-fzf-native.nvim',
        build = 'make',
        cond = function() return vim.fn.executable 'make' == 1 end,
      },
      { 'nvim-telescope/telescope-ui-select.nvim' },
      { 'nvim-tree/nvim-web-devicons', enabled = vim.g.have_nerd_font },
      -- Extension for better ripgrep arguments support
      { 'nvim-telescope/telescope-live-grep-args.nvim' },
    },
    -- Refactored keybindings into lazy.nvim keys table
    keys = {
      -- Basic Search
      { '<leader>sh', function() require('telescope.builtin').help_tags() end, desc = '[S]earch [H]elp' },
      { '<leader>sk', function() require('telescope.builtin').keymaps() end, desc = '[S]earch [K]eymaps' },
      { '<leader>sf', function() require('telescope.builtin').find_files() end, desc = '[S]earch [F]iles' },
      { '<leader>sc', function() require('telescope.builtin').commands() end, desc = '[S]earch [C]ommands' },
      { '<leader>sd', function() require('telescope.builtin').diagnostics() end, desc = '[S]earch [D]iagnostics' },
      { '<leader>sr', function() require('telescope.builtin').resume() end, desc = '[S]earch [R]esume' },
      { '<leader>sg', function() require('telescope.builtin').live_grep() end, desc = '[S]earch by [G]rep' },
      { '<leader>s.', function() require('telescope.builtin').oldfiles() end, desc = '[S]earch Recent Files' },
      { '<leader><leader>', function() require('telescope.builtin').buffers() end, desc = 'Find existing buffers' },
      { '<leader>sw', function() require('telescope.builtin').grep_string() end, mode = { 'n', 'v' }, desc = '[S]earch current [W]ord' },

      -- Specialized Search
      { '<leader>sn', function() require('telescope.builtin').find_files { cwd = vim.fn.stdpath 'config' } end, desc = '[S]earch [N]eovim files' },
      {
        '<leader>sR',
        function() require('telescope').extensions.live_grep_args.live_grep_args() end,
        desc = '[S]earch by Grep with [R]aw Arguments',
      },
      {
        '<leader>/',
        function()
          require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
            winblend = 10,
            previewer = false,
          })
        end,
        desc = 'Fuzzily search in current buffer',
      },
      {
        '<leader>s/',
        function()
          require('telescope.builtin').live_grep {
            grep_open_files = true,
            prompt_title = 'Live Grep in Open Files',
          }
        end,
        desc = '[S]earch [/] in Open Files',
      },
      {
        '<leader>gf',
        function()
          require('telescope.builtin').git_bcommits {
            prompt_title = 'Current File History (Commits)',
          }
        end,
        desc = '[G]it [F]ile History',
      },
      {
        '<leader>uC',
        function()
          require('telescope.builtin').colorscheme {
            enable_preview = true,
          }
        end,
        desc = '[U]I [C]olorscheme with Preview',
      },
    },
    config = function()
      -- [[ Configure Telescope ]]
      -- See `:help telescope` and `:help telescope.setup()`
      require('telescope').setup {
        defaults = {
          -- General appearance
          path_display = { 'smart' },
          mappings = {
            i = {
              ['<C-k>'] = require('telescope.actions').move_selection_previous, -- move to prev result
              ['<C-j>'] = require('telescope.actions').move_selection_next, -- move to next result
            },
          },
        },
        extensions = {
          ['ui-select'] = {
            require('telescope.themes').get_dropdown(),
          },
          -- live_grep_args configuration
          live_grep_args = {
            auto_quoting = true, -- enable/disable auto-quoting
          },
        },
      }

      -- Load extensions if installed
      pcall(require('telescope').load_extension, 'fzf')
      pcall(require('telescope').load_extension, 'ui-select')
      pcall(require('telescope').load_extension, 'live_grep_args')

      -- [[ LSP Keybindings via Autocmd ]]
      -- These are only mapped when an LSP attaches to a buffer
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('telescope-lsp-attach', { clear = true }),
        callback = function(event)
          local buf = event.buf
          local builtin = require 'telescope.builtin'

          -- Navigation
          vim.keymap.set('n', 'gd', builtin.lsp_definitions, { buffer = buf, desc = 'Goto Definition' })
          vim.keymap.set('n', 'gr', builtin.lsp_references, { buffer = buf, desc = 'Goto References' })
          vim.keymap.set('n', 'gI', builtin.lsp_implementations, { buffer = buf, desc = 'Goto Implementation' })
          vim.keymap.set('n', 'gt', builtin.lsp_type_definitions, { buffer = buf, desc = 'Type Definition' })
          vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, { buffer = buf, desc = 'Goto Declaration' })

          -- Symbol Search (Your ss/sS request)
          vim.keymap.set('n', '<leader>ss', builtin.lsp_document_symbols, { buffer = buf, desc = 'Search Document Symbols' })
          vim.keymap.set('n', '<leader>sS', builtin.lsp_dynamic_workspace_symbols, { buffer = buf, desc = 'Search Workspace Symbols' })
        end,
      })
    end,
  },
}
