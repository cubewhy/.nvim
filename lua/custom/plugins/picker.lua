return {
  {
    'nvim-telescope/telescope.nvim',
    event = 'BufEnter',
    cmd = 'Telescope',
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
      { 'debugloop/telescope-undo.nvim' },
    },
    -- Refactored keybindings into lazy.nvim keys table
    keys = {
      -- Basic Search
      { '<leader>sh', function() require('telescope.builtin').help_tags() end, desc = 'Search Help' },
      { '<leader>sk', function() require('telescope.builtin').keymaps() end, desc = 'Search Keymaps' },
      { '<leader>sf', function() require('telescope.builtin').find_files() end, desc = 'Search Files' },
      { '<leader>sc', function() require('telescope.builtin').commands() end, desc = 'Search Commands' },
      { '<leader>sd', function() require('telescope.builtin').diagnostics() end, desc = 'Search Diagnostics' },
      {
        '<leader>sD',
        function() require('telescope.builtin').diagnostics { bufnr = 0 } end,
        desc = 'Search Document Diagnostics',
      },
      { '<leader>sr', function() require('telescope.builtin').resume() end, desc = 'Search Resume' },
      { '<leader>sg', function() require('telescope.builtin').live_grep() end, desc = 'Search by Grep' },
      { '<leader>/', function() require('telescope.builtin').live_grep() end, desc = 'Live Grep In Workspace' },
      { '<leader>su', function() require('telescope').extensions.undo.undo() end, desc = 'Search Undo history' },
      { '<leader>s.', function() require('telescope.builtin').oldfiles() end, desc = 'Search Recent Files' },
      { '<leader><leader>', function() require('telescope.builtin').buffers() end, desc = 'Find existing buffers' },
      {
        '<leader>sw',
        function() require('telescope.builtin').grep_string() end,
        mode = { 'n', 'v' },
        desc = 'Search current Word',
      },

      -- Specialized Search
      { '<leader>sn', function() require('telescope.builtin').find_files { cwd = vim.fn.stdpath 'config' } end, desc = 'Search Neovim files' },
      {
        '<leader>sb',
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
        desc = 'Search in Open Files',
      },
      {
        '<leader>uC',
        function()
          require('telescope.builtin').colorscheme {
            enable_preview = true,
          }
        end,
        desc = 'Colorscheme',
      },
    },
    config = function()
      -- [[ Configure Telescope ]]
      -- See `:help telescope` and `:help telescope.setup()`

      local telescope = require 'telescope'
      local actions = require 'telescope.actions'

      local function flash(prompt_bufnr)
        require('flash').jump {
          pattern = '^',
          label = { after = { 0, 0 } },
          search = {
            mode = 'search',
            exclude = {
              function(win) return vim.bo[vim.api.nvim_win_get_buf(win)].filetype ~= 'TelescopeResults' end,
            },
          },
          action = function(match)
            local picker = require('telescope.actions.state').get_current_picker(prompt_bufnr)
            picker:set_selection(match.pos[1] - 1)
          end,
        }
      end

      telescope.setup {
        defaults = {
          -- General appearance
          path_display = { 'smart' },
          mappings = {
            i = {
              ['<C-k>'] = require('telescope.actions').move_selection_previous, -- move to prev result
              ['<C-j>'] = require('telescope.actions').move_selection_next, -- move to next result
              ['<C-y>'] = require('telescope.actions').select_default, -- move to next result

              ['<C-Up>'] = actions.cycle_history_prev,
              ['<C-Down>'] = actions.cycle_history_next,
              ['<c-s>'] = flash,
            },
            n = {
              ['<C-k>'] = require('telescope.actions').move_selection_previous, -- move to prev result
              ['<C-j>'] = require('telescope.actions').move_selection_next, -- move to next result
              ['<C-y>'] = require('telescope.actions').select_default, -- move to next result

              ['<C-Up>'] = actions.cycle_history_prev,
              ['<C-Down>'] = actions.cycle_history_next,

              ['q'] = require('telescope.actions').close,
              ['s'] = flash,
            },
          },
          -- get_selection_window = function()
          --   local wins = vim.api.nvim_list_wins()
          --   for _, win in ipairs(wins) do
          --     local buf = vim.api.nvim_win_get_buf(win)
          --     if vim.bo[buf].buftype == '' and not vim.wo[win].winfixbuf then return win end
          --   end
          --   vim.cmd 'vsplit'
          --   local new_win = vim.api.nvim_get_current_win()
          --   vim.wo[new_win].winfixbuf = false
          --   return new_win
          -- end,
        },
        extensions = {
          ['ui-select'] = {
            require('telescope.themes').get_dropdown(),
          },
          -- live_grep_args configuration
          live_grep_args = {
            auto_quoting = true, -- enable/disable auto-quoting
          },
          undo = {},
        },
      }

      -- Load extensions if installed
      pcall(telescope.load_extension, 'fzf')
      pcall(telescope.load_extension, 'ui-select')
      pcall(telescope.load_extension, 'live_grep_args')
      pcall(telescope.load_extension, 'undo')

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
  {
    'MagicDuck/grug-far.nvim',
    keys = {
      {
        '<leader>sA',
        function() require('grug-far').open { engine = 'astgrep' } end,
        desc = 'Search Astgrep (grug-far)',
      },
      {
        '<leader>sR',
        function() require('grug-far').open {} end,
        desc = 'Search & Replace (grug-far)',
      },
    },
    config = function()
      -- optional setup call to override plugin options
      -- alternatively you can set options with vim.g.grug_far = { ... }
      require('grug-far').setup {
        -- options, see Configuration section below
        -- there are no required options atm
      }
    end,
  },
}
