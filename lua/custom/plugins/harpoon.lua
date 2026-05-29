return {
  'ThePrimeagen/harpoon',
  branch = 'harpoon2',
  dependencies = { 'nvim-lua/plenary.nvim' },
  config = function()
    local harpoon = require 'harpoon'

    harpoon:setup {
      settings = {
        save_on_toggle = true,
        sync_on_ui_close = true,
      },
    }

    harpoon:extend {
      ADD = function() vim.api.nvim_exec_autocmds('User', { pattern = 'HarpoonUpdate' }) end,
      REMOVE = function() vim.api.nvim_exec_autocmds('User', { pattern = 'HarpoonUpdate' }) end,
      REORDER = function() vim.api.nvim_exec_autocmds('User', { pattern = 'HarpoonUpdate' }) end,
      UI_CREATE = function(cx)
        vim.api.nvim_create_autocmd('BufLeave', {
          buffer = cx.bufnr,
          callback = function()
            vim.schedule(function() vim.api.nvim_exec_autocmds('User', { pattern = 'HarpoonUpdate' }) end)
          end,
        })
      end,
    }

    vim.keymap.set('n', '<leader>a', function()
      harpoon:list():add()
      vim.api.nvim_exec_autocmds('User', { pattern = 'HarpoonUpdate' })
      vim.cmd 'redrawtabline'
    end, { desc = 'Harpoon Add File' })

    vim.keymap.set('n', '<C-e>', function() harpoon.ui:toggle_quick_menu(harpoon:list()) end, { desc = 'Harpoon Toggle Menu' })

    for i = 1, 9 do
      vim.keymap.set('n', '<M-' .. i .. '>', function() harpoon:list():select(i) end, { desc = 'Harpoon to file ' .. i })
    end
  end,
}
