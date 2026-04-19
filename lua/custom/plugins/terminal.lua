local function smart_toggle_term()
  local ok, Terminal = pcall(require, 'toggleterm.terminal')
  if not ok then return end

  local count = vim.v.count

  if vim.bo.buftype == 'terminal' then
    local target_num = count > 0 and count or vim.b.toggle_number
    local term = Terminal.get_or_create_term(target_num)
    if term then
      term:toggle()
      return
    end
  end

  local target_num = count > 0 and count or 1
  local term = Terminal.get_or_create_term(target_num)
  term:toggle()
end

local function toggle_float_term()
  local count = vim.v.count
  local id = count > 0 and count or 99

  local float_term = require('toggleterm.terminal').Terminal:new {
    id = id,
    direction = 'float',
    float_opts = {
      border = 'curved', -- 'single', 'double', 'shadow', 'curved'
    },
    on_open = function(_)
      if _G.set_terminal_keymaps then _G.set_terminal_keymaps() end
    end,
  }
  float_term:toggle()
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
      { '<leader>ft', toggle_float_term, mode = { 'n' }, desc = 'Float Terminal' },
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
        callback = function(args)
          if vim.bo.buftype == 'terminal' then
            -- if vim.fn.has 'nvim-0.10' == 1 then vim.wo.winfixbuf = true end
            set_terminal_keymaps()
            vim.w.toggleterm_buf = args.buf
          end
        end,
      })

      vim.api.nvim_create_autocmd('BufEnter', {
        callback = function(args)
          local win = vim.api.nvim_get_current_win()
          local buf = args.buf

          if vim.w[win].toggleterm_buf and vim.bo[buf].buftype ~= 'terminal' then
            local term_buf = vim.w[win].toggleterm_buf
            if not vim.api.nvim_buf_is_valid(term_buf) then
              vim.w[win].toggleterm_buf = nil
              return
            end

            vim.api.nvim_win_set_buf(win, term_buf)

            local target_win
            for _, w in ipairs(vim.api.nvim_list_wins()) do
              local b = vim.api.nvim_win_get_buf(w)
              if vim.bo[b].buftype == '' and w ~= win then
                target_win = w
                break
              end
            end

            if target_win then
              vim.api.nvim_set_current_win(target_win)
              vim.api.nvim_win_set_buf(target_win, buf)
            else
              vim.cmd 'wincmd p'
              vim.cmd 'split'
              vim.api.nvim_win_set_buf(0, buf)
            end
          end
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
