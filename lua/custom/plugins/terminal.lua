local function smart_toggle_term()
  local ok, Terminal = pcall(require, 'toggleterm.terminal')
  if not ok then return end

  if vim.bo.buftype == 'terminal' then
    local term = Terminal.get_or_create_term(vim.b.toggle_number)
    if term then
      term:toggle()
      return
    end
  end

  local term1 = Terminal.get_or_create_term(1)
  term1:toggle()
end

return {
  {
    'akinsho/toggleterm.nvim',
    version = '*',
    opts = {
      direction = 'horizontal',
      size = 15,
      hide_numbers = true,
      shade_terminals = false,
      start_in_insert = true,
      insert_mappings = true,
      persist_size = false,
    },
    keys = {
      { '<C-_>', smart_toggle_term, mode = { 'n', 't' }, desc = 'Terminal (Ctrl+/)' },
      { '<C-/>', smart_toggle_term, mode = { 'n', 't' }, desc = 'Terminal (Ctrl+/)' },

      { '1<C-/>', '<cmd>1ToggleTerm<cr>', desc = 'Terminal 1' },
      { '2<C-/>', '<cmd>2ToggleTerm<cr>', desc = 'Terminal 2' },
      { '3<C-/>', '<cmd>3ToggleTerm<cr>', desc = 'Terminal 3' },
      { '4<C-/>', '<cmd>4ToggleTerm<cr>', desc = 'Terminal 4' },
      { '5<C-/>', '<cmd>5ToggleTerm<cr>', desc = 'Terminal 5' },
      { '6<C-/>', '<cmd>6ToggleTerm<cr>', desc = 'Terminal 6' },
      { '7<C-/>', '<cmd>7ToggleTerm<cr>', desc = 'Terminal 7' },
      { '8<C-/>', '<cmd>8ToggleTerm<cr>', desc = 'Terminal 8' },
      { '9<C-/>', '<cmd>9ToggleTerm<cr>', desc = 'Terminal 9' },
    },
    config = function(_, opts)
      require('toggleterm').setup(opts)

      function _G.set_terminal_keymaps()
        local opts = { buffer = 0 }
        vim.keymap.set('t', '<esc>', [[<C-\><C-n>]], opts)

        vim.keymap.set('t', '<C-h>', [[<C-\><C-n><C-w>h]], opts)
        vim.keymap.set('t', '<C-j>', [[<C-\><C-n><C-w>j]], opts)
        vim.keymap.set('t', '<C-k>', [[<C-\><C-n><C-w>k]], opts)
        vim.keymap.set('t', '<C-l>', [[<C-\><C-n><C-w>l]], opts)
      end

      vim.api.nvim_create_autocmd({ 'TermOpen', 'BufEnter' }, {
        pattern = 'term://*toggleterm#*',
        callback = function()
          if vim.bo.buftype == 'terminal' then set_terminal_keymaps() end
        end,
      })
    end,
  },
  -- {
  --   'https://git.sr.ht/~havi/telescope-toggleterm.nvim',
  --   event = 'TermOpen',
  --   requires = {
  --     'akinsho/nvim-toggleterm.lua',
  --     'nvim-telescope/telescope.nvim',
  --     'nvim-lua/popup.nvim',
  --     'nvim-lua/plenary.nvim',
  --   },
  --   config = function() require('telescope').load_extension 'toggleterm' end,
  -- },
}
