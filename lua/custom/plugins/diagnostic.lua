return {
  {
    'rachartier/tiny-inline-diagnostic.nvim',
    event = 'VeryLazy',
    priority = 1000,
    config = function()
      vim.diagnostic.config { virtual_text = false }
      require('tiny-inline-diagnostic').setup()
    end,
  },
  {
    'neovim/nvim-lspconfig',
    keys = {
      {
        '<leader>ud',
        function()
          local is_enabled = vim.diagnostic.is_enabled()
          local new_state = not is_enabled

          vim.diagnostic.enable(new_state)
        end,
        desc = 'Toggle [D]iagnostics',
      },
    },
    opts = {
      diagnostics = {
        virtual_text = false,
      },
    },
  },
  {
    'folke/trouble.nvim',
    opts = {}, -- for default options, refer to the configuration section for custom setup.
    cmd = 'Trouble',
    keys = {
      {
        '<leader>xx',
        '<cmd>Trouble diagnostics toggle<cr>',
        desc = 'Diagnostics (Trouble)',
      },
      {
        '<leader>xX',
        '<cmd>Trouble diagnostics toggle filter.buf=0<cr>',
        desc = 'Buffer Diagnostics (Trouble)',
      },
      {
        '<leader>cs',
        '<cmd>Trouble symbols toggle focus=false<cr>',
        desc = 'Symbols (Trouble)',
      },
      {
        '<leader>cl',
        '<cmd>Trouble lsp toggle focus=false win.position=right<cr>',
        desc = '[L]SP Definitions / references / ... (Trouble)',
      },
      {
        '<leader>xL',
        '<cmd>Trouble loclist toggle<cr>',
        desc = '[L]ocation List (Trouble)',
      },
      {
        '<leader>xq',
        function()
          local qf_exists = false
          for _, win in pairs(vim.fn.getwininfo()) do
            if win.quickfix == 1 then
              qf_exists = true
              break
            end
          end
          if qf_exists then
            vim.cmd 'cclose'
          else
            vim.cmd 'copen'
          end
        end,
        desc = '[Q]uickfix List',
      },
      {
        '<leader>xQ',
        '<cmd>Trouble qflist toggle<cr>',
        desc = '[Q]uickfix List (Trouble)',
      },
    },
  },
}
