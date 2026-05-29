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

    vim.keymap.set('n', '<leader>a', function() harpoon:list():add() end, { desc = 'Harpoon Add File' })

    vim.keymap.set('n', '<C-e>', function() harpoon.ui:toggle_quick_menu(harpoon:list()) end, { desc = 'Harpoon Toggle Menu' })

    for i = 1, 9 do
      vim.keymap.set('n', '<M-' .. i .. '>', function() harpoon:list():select(i) end, { desc = 'Harpoon to file ' .. i })
    end

    vim.keymap.set('n', '<C-S-P>', function() harpoon:list():prev() end, { desc = 'Harpoon Prev' })
    vim.keymap.set('n', '<C-S-N>', function() harpoon:list():next() end, { desc = 'Harpoon Next' })
  end,
}
