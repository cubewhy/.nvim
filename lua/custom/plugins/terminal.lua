local function smart_toggle_term()
  local ok, Terminal = pcall(require, 'toggleterm.terminal')
  if not ok then
    return
  end

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
      persist_size = true,
    },
    keys = {
      { '<C-_>',      smart_toggle_term,      mode = { 'n', 't' }, desc = 'Terminal (Ctrl+/)' },
      { '<C-/>',      smart_toggle_term,      mode = { 'n', 't' }, desc = 'Terminal (Ctrl+/)' },

      { '<leader>t1', '<cmd>1ToggleTerm<cr>', desc = 'Terminal 1' },
      { '<leader>t2', '<cmd>2ToggleTerm<cr>', desc = 'Terminal 2' },
      { '<leader>t3', '<cmd>3ToggleTerm<cr>', desc = 'Terminal 3' },
      { '<leader>t4', '<cmd>4ToggleTerm<cr>', desc = 'Terminal 4' },
      { '<leader>t5', '<cmd>5ToggleTerm<cr>', desc = 'Terminal 5' },
      { '<leader>t6', '<cmd>6ToggleTerm<cr>', desc = 'Terminal 6' },
      { '<leader>t7', '<cmd>7ToggleTerm<cr>', desc = 'Terminal 7' },
      { '<leader>t8', '<cmd>8ToggleTerm<cr>', desc = 'Terminal 8' },
      { '<leader>t9', '<cmd>9ToggleTerm<cr>', desc = 'Terminal 9' },
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
          if vim.bo.buftype == 'terminal' then
            set_terminal_keymaps()
          end
        end,
      })
    end,
  },
}
