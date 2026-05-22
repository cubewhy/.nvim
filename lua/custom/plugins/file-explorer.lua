return {
  {
    'stevearc/oil.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    lazy = false,
    keys = {
      { '-', function() require('oil').open() end, desc = 'Oil' },
    },
    opts = {
      default_file_explorer = true,
      win_options = {
        winblend = 10,
      },
      float = {
        padding = 2,
        max_width = 80,
        max_height = 20,
        border = 'rounded',
      },
      view_options = {
        show_hidden = false,
        is_hidden_file = function(name, _)
          local ignored = { 'node_modules', '.direnv', '.git' }
          for _, pattern in ipairs(ignored) do
            if name == pattern then return true end
          end
          return false
        end,
      },
      columns = {
        'icon',
        -- 'permissions',
        -- 'size',
        -- 'mtime',
      },
      buf_options = {
        buflisted = false,
        bufhidden = 'hide',
      },
      skip_confirm_for_simple_edits = true,
      -- Constrain the cursor to the editable parts of the oil buffer
      -- Set to `false` to disable, or "name" to keep it on the file names
      constrain_cursor = 'editable',
      -- Set to true to watch the filesystem for changes and reload oil
      watch_for_changes = true,
      lsp_file_methods = {
        -- Enable or disable LSP file operations
        enabled = true,
        -- Time to wait for LSP file operations to complete before skipping
        timeout_ms = 1000,
        -- Set to true to autosave buffers that are updated with LSP willRenameFiles
        -- Set to "unmodified" to only save unmodified buffers
        autosave_changes = 'unmodified',
      },
      keymaps = {
        ['g?'] = 'show_help',
        ['<CR>'] = 'actions.select',
        ['<C-s>'] = { 'actions.select', opts = { vertical = true } },
        ['<C-h>'] = { 'actions.select', opts = { horizontal = true } },
        ['<C-t>'] = { 'actions.select', opts = { tab = true } },
        ['<C-p>'] = 'actions.preview',
        ['<C-c>'] = 'actions.close',
        ['<C-l>'] = 'actions.refresh',
        ['-'] = 'actions.parent',
        ['_'] = 'actions.open_cwd',
        ['`'] = { 'actions.cd', mode = 'n' },
        ['g~'] = { 'actions.cd', opts = { scope = 'tab' }, mode = 'n' },
        ['gs'] = 'actions.change_sort',
        ['gx'] = 'actions.open_external',
        ['g.'] = 'actions.toggle_hidden',
      },
    },
    setup = function(_, opts)
      require('oil').setup(opts)

      vim.api.nvim_create_autocmd('User', {
        pattern = 'OilActionsPost',
        callback = function(event)
          if event.data.actions[1].type == 'move' then Snacks.rename.on_rename_file(event.data.actions[1].src_url, event.data.actions[1].dest_url) end
        end,
      })
    end,
  },
}
