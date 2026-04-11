local map = vim.keymap.set
-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`

-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`
map('n', '<Esc>', '<cmd>nohlsearch<CR><Esc>', { noremap = true, silent = true })

map('n', '<leader>xq', vim.diagnostic.setloclist, { desc = 'Open diagnostic Quickfix list' })

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
map('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- TIP: Disable arrow keys in normal mode
-- map('n', '<left>', '<cmd>echo "Use h to move!!"<CR>')
-- map('n', '<right>', '<cmd>echo "Use l to move!!"<CR>')
-- map('n', '<up>', '<cmd>echo "Use k to move!!"<CR>')
-- map('n', '<down>', '<cmd>echo "Use j to move!!"<CR>')

-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
--
--  See `:help wincmd` for a list of all window commands
map('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
map('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
map('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
map('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

map('n', '<leader>-', '<C-w>s', { desc = 'Split Below' })
map('n', '<leader>|', '<C-w>v', { desc = 'Split Right' })
map('n', '<leader>w-', '<C-w>s', { desc = 'Split Window Below' })
map('n', '<leader>w|', '<C-w>v', { desc = 'Split Window Right' })
map('n', '<leader>wd', '<C-w>c', { desc = 'Close Window' })
map('n', '<leader>ww', '<C-w>w', { desc = 'Switch Window' })
map('n', '<leader>wh', '<C-w>h', { desc = 'Move to Left' })
map('n', '<leader>wj', '<C-w>j', { desc = 'Move Down' })
map('n', '<leader>wk', '<C-w>k', { desc = 'Move Up' })
map('n', '<leader>wl', '<C-w>l', { desc = 'Move to Right' })
map('n', '<leader>wo', '<C-w>o', { desc = 'Close Other Windows' })
map('n', '<leader>w=', '<C-w>=', { desc = 'Equalize size' })
map('n', '<leader>w>', '<cmd>vertical resize +5<cr>', { desc = 'Increase Width' })
map('n', '<leader>w<', '<cmd>vertical resize -5<cr>', { desc = 'Decrease Width' })

map('n', '[e', function()
  vim.diagnostic.jump {
    count = -1,
    severity = vim.diagnostic.severity.ERROR,
  }
end, { desc = 'Go to previous Error' })

map('n', ']e', function()
  vim.diagnostic.jump {
    count = 1,
    severity = vim.diagnostic.severity.ERROR,
  }
end, { desc = 'Go to next Error' })

map('n', '[w', function()
  vim.diagnostic.jump {
    count = -1,
  }
end, { desc = 'Go to previous Warning/Diagnostic' })

map('n', ']w', function()
  vim.diagnostic.jump {
    count = 1,
  }
end, { desc = 'Go to next Warning/Diagnostic' })

map(
  'n',
  '[h',
  function()
    vim.diagnostic.jump {
      count = -1,
      severity = vim.diagnostic.severity.HINT,
      float = { border = 'none' },
    }
  end,
  { desc = 'Go to previous Hint' }
)

map('n', ']h', function()
  vim.diagnostic.jump {
    count = 1,
    float = { border = 'none' },
  }
end, { desc = 'Go to next Hint' })

-- indent
map('n', '<A-h>', '<<', { desc = 'Indent left' })
map('v', '<A-h>', '<gv', { desc = 'Indent left' })

map('n', '<A-l>', '>>', { desc = 'Indent right' })
map('v', '<A-l>', '>gv', { desc = 'Indent right' })

vim.keymap.del('n', 'grn')
vim.keymap.del({ 'n', 'x' }, 'gra')
vim.keymap.del('n', 'grr')
vim.keymap.del('n', 'gri')
vim.keymap.del('n', 'grt')
vim.keymap.del('n', 'grx')
vim.keymap.del('n', 'gO')
