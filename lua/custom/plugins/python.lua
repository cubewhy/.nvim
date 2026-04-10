return {
  {
    'linux-cultist/venv-selector.nvim',
    dependencies = {
      { 'nvim-telescope/telescope.nvim', version = '*', dependencies = { 'nvim-lua/plenary.nvim' } },
    },
    ft = 'python',
    opts = {
      options = {
        override_notify = false,
      },
      search = {}, -- custom search definitions
    },
    config = function(_, opts)
      require('venv-selector').setup(opts)

      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('VenvSelectorKeymap', { clear = true }),
        desc = 'Set venv-selector keybindings via which-key',
        callback = function(args)
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          if not client then return end

          local allowed_lsps = {
            pyright = true,
            basedpyright = true,
            ruff = true,
            pylsp = true,
            jedi_language_server = true,
          }

          if allowed_lsps[client.name] then
            local has_wk, wk = pcall(require, 'which-key')
            if has_wk then
              wk.add {
                {
                  '<leader>cv',
                  '<cmd>VenvSelect<cr>',
                  desc = 'Select venv',
                  icon = { icon = ' ', color = 'yellow' },
                  buffer = args.buf,
                },
              }
            else
              vim.keymap.set('n', '<leader>cv', '<cmd>VenvSelect<cr>', {
                buffer = args.buf,
                desc = 'Select venv',
                silent = true,
              })
            end
          end
        end,
      })
    end,
  },
  {
    'Vimjas/vim-python-pep8-indent',
  },
}
