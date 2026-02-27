-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`

-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

vim.keymap.set('n', '<leader>xq', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- TIP: Disable arrow keys in normal mode
-- vim.keymap.set('n', '<left>', '<cmd>echo "Use h to move!!"<CR>')
-- vim.keymap.set('n', '<right>', '<cmd>echo "Use l to move!!"<CR>')
-- vim.keymap.set('n', '<up>', '<cmd>echo "Use k to move!!"<CR>')
-- vim.keymap.set('n', '<down>', '<cmd>echo "Use j to move!!"<CR>')

-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
--
--  See `:help wincmd` for a list of all window commands
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

vim.keymap.set({ 'n', 'i', 'v' }, '<C-s>', '<cmd>w<cr><esc>', { desc = 'Save File' })
-- vim.keymap.set({ 'n', 'i', 'v' }, '<C-a>', '<cmd>wa<cr><esc>', { desc = 'Save All Files' })

vim.keymap.set('n', '<leader>-', '<C-w>s', { desc = 'Split Below' })
vim.keymap.set('n', '<leader>|', '<C-w>v', { desc = 'Split Right' })
vim.keymap.set('n', '<leader>w-', '<C-w>s', { desc = 'Split Window Below' })
vim.keymap.set('n', '<leader>w|', '<C-w>v', { desc = 'Split Window Right' })
vim.keymap.set('n', '<leader>wd', '<C-w>c', { desc = 'Close Window' })
vim.keymap.set('n', '<leader>ww', '<C-w>w', { desc = 'Switch Window' })
vim.keymap.set('n', '<leader>wh', '<C-w>h', { desc = 'Move to Left' })
vim.keymap.set('n', '<leader>wj', '<C-w>j', { desc = 'Move Down' })
vim.keymap.set('n', '<leader>wk', '<C-w>k', { desc = 'Move Up' })
vim.keymap.set('n', '<leader>wl', '<C-w>l', { desc = 'Move to Right' })
vim.keymap.set('n', '<leader>wo', '<C-w>o', { desc = 'Close Other Windows' })
vim.keymap.set('n', '<leader>w=', '<C-w>=', { desc = 'Equalize size' })
vim.keymap.set('n', '<leader>w>', '<cmd>vertical resize +5<cr>', { desc = 'Increase Width' })
vim.keymap.set('n', '<leader>w<', '<cmd>vertical resize -5<cr>', { desc = 'Decrease Width' })

vim.keymap.set('n', '[e', function() vim.diagnostic.goto_prev { severity = vim.diagnostic.severity.ERROR } end, { desc = 'Go to previous [E]rror' })
vim.keymap.set('n', ']e', function() vim.diagnostic.goto_next { severity = vim.diagnostic.severity.ERROR } end, { desc = 'Go to next [E]rror' })
vim.keymap.set('n', '[w', function() vim.diagnostic.goto_prev() end, { desc = 'Go to previous [W]arning/Diagnostic' })
vim.keymap.set('n', ']w', function() vim.diagnostic.goto_next() end, { desc = 'Go to next [W]arning/Diagnostic' })
vim.keymap.set(
  'n',
  '[h',
  function()
    vim.diagnostic.goto_prev {
      severity = vim.diagnostic.severity.HINT,
      float = { border = 'none' },
    }
  end,
  { desc = 'Go to previous [H]int' }
)
vim.keymap.set(
  'n',
  ']h',
  function()
    vim.diagnostic.goto_next {
      severity = vim.diagnostic.severity.HINT,
      float = { border = 'none' },
    }
  end,
  { desc = 'Go to next [H]int' }
)

-- indent
vim.keymap.set('n', '<A-h>', '<<', { desc = 'Indent left' })
vim.keymap.set('v', '<A-h>', '<gv', { desc = 'Indent left' })

vim.keymap.set('n', '<A-l>', '>>', { desc = 'Indent right' })
vim.keymap.set('v', '<A-l>', '>gv', { desc = 'Indent right' })
