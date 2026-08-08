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
    opts = {
      diagnostics = {
        virtual_text = false,
      },
    },
  },
  {
    'folke/trouble.nvim',
    opts = {},
    cmd = 'Trouble',
    specs = {
      'folke/snacks.nvim',
      opts = function(_, opts)
        return vim.tbl_deep_extend('force', opts or {}, {
          picker = {
            actions = require('trouble.sources.snacks').actions,
            win = {
              input = {
                keys = {
                  ['<c-t>'] = {
                    'trouble_open',
                    mode = { 'n', 'i' },
                  },
                },
              },
            },
          },
        })
      end,
    },
    keys = {
      -- Trouble toggle mappings
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
        '<leader>xe',
        function()
          require('trouble').toggle {
            mode = 'diagnostics',
            filter = { severity = vim.diagnostic.severity.ERROR },
          }
        end,
        desc = 'Workspace Errors',
      },
      {
        '<leader>xE',
        function()
          require('trouble').toggle {
            mode = 'diagnostics',
            filter = {
              buf = 0,
              severity = vim.diagnostic.severity.ERROR,
            },
          }
        end,
        desc = 'Buffer Errors',
      },
      {
        '<leader>xw',
        function()
          require('trouble').toggle {
            mode = 'diagnostics',
            filter = { severity = vim.diagnostic.severity.WARN },
          }
        end,
        desc = 'Workspace Warnings',
      },
      {
        '<leader>xW',
        function()
          require('trouble').toggle {
            mode = 'diagnostics',
            filter = {
              buf = 0,
              severity = vim.diagnostic.severity.WARN,
            },
          }
        end,
        desc = 'Buffer Warnings',
      },
      {
        '<leader>cs',
        '<cmd>Trouble symbols toggle focus=false<cr>',
        desc = 'Symbols (Trouble)',
      },
      {
        '<leader>cl',
        '<cmd>Trouble lsp toggle focus=false win.position=right<cr>',
        desc = 'LSP Definitions / references / ... (Trouble)',
      },
      {
        '<leader>xL',
        '<cmd>Trouble loclist toggle<cr>',
        desc = 'Location List (Trouble)',
      },
      {
        '<leader>xQ',
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
        desc = 'Quickfix List',
      },
      {
        '<leader>xq',
        '<cmd>Trouble qflist toggle<cr>',
        desc = 'Quickfix List (Trouble)',
      },
    },
  },
}
