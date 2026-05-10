return {
  {
    'folke/snacks.nvim',
    priority = 1000,
    lazy = false,
    ---@type snacks.Config
    opts = {
      picker = {
        enabled = true,
        ui_select = true,
        formatters = {
          file = {
            filename_first = true,
          },
        },
        layout = {
          preset = 'telescope',
        },
        win = {
          input = {
            keys = {
              ['<C-y>'] = { 'confirm', mode = { 'i', 'n' } },
            },
          },
        },
      },
      input = { enabled = true },
    },
    keys = {
      -- Basic Search
      { '<leader>sh', function() Snacks.picker.help() end, desc = 'Search Help' },
      { '<leader>sk', function() Snacks.picker.keymaps() end, desc = 'Search Keymaps' },
      { '<leader>sf', function() Snacks.picker.files() end, desc = 'Search Files' },
      { '<leader>sc', function() Snacks.picker.commands() end, desc = 'Search Commands' },
      { '<leader>sj', function() Snacks.picker.jumps() end, desc = 'Search Jumplist' },
      { '<leader>sd', function() Snacks.picker.diagnostics() end, desc = 'Search Diagnostics' },
      { '<leader>sD', function() Snacks.picker.diagnostics_buffer() end, desc = 'Search Document Diagnostics' },
      { '<leader>sR', function() Snacks.picker.resume() end, desc = 'Search Resume' },
      { '<leader>sg', function() Snacks.picker.grep() end, desc = 'Search by Grep' },
      { '<leader>/', function() Snacks.picker.grep() end, desc = 'Grep In Workspace' },
      { '<leader>su', function() Snacks.picker.undo() end, desc = 'Search Undo history' },
      { '<leader>s.', function() Snacks.picker.recent() end, desc = 'Search Recent Files' },
      { '<leader><leader>', function() Snacks.picker.buffers() end, desc = 'Find existing buffers' },
      { '<leader>sw', function() Snacks.picker.grep_word() end, desc = 'Search current Word', mode = { 'n', 'v' } },

      -- Specialized Search
      { '<leader>sn', function() Snacks.picker.files { cwd = vim.fn.stdpath 'config' } end, desc = 'Search Neovim files' },
      { '<leader>sb', function() Snacks.picker.lines() end, desc = 'Buffer Fuzzy Find' },
      { '<leader>s/', function() Snacks.picker.grep_buffers() end, desc = 'Search in Open Files' },
      { '<leader>uC', function() Snacks.picker.colorschemes() end, desc = 'Colorschemes' },
    },
    config = function(_, opts)
      require('snacks').setup(opts)

      -- [[ LSP Keybindings via Autocmd ]]
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('snacks-lsp-attach', { clear = true }),
        callback = function(event)
          local buf = event.buf

          -- Navigation
          vim.keymap.set('n', 'gd', function() Snacks.picker.lsp_definitions() end, { buffer = buf, desc = 'Goto Definition' })
          vim.keymap.set('n', 'gr', function() Snacks.picker.lsp_references() end, { buffer = buf, desc = 'Goto References' })
          vim.keymap.set('n', 'gI', function() Snacks.picker.lsp_implementations() end, { buffer = buf, desc = 'Goto Implementation' })
          vim.keymap.set('n', 'gt', function() Snacks.picker.lsp_type_definitions() end, { buffer = buf, desc = 'Type Definition' })
          vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, { buffer = buf, desc = 'Goto Declaration' })

          -- Symbol Search
          vim.keymap.set('n', '<leader>ss', function() Snacks.picker.lsp_symbols() end, { buffer = buf, desc = 'Search Document Symbols' })
          vim.keymap.set('n', '<leader>sS', function() Snacks.picker.lsp_workspace_symbols() end, { buffer = buf, desc = 'Search Workspace Symbols' })
        end,
      })
    end,
  },
}
