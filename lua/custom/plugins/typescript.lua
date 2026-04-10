return {
  {
    'yioneko/nvim-vtsls',
    dependencies = { 'neovim/nvim-lspconfig' },
    config = function()
      require('lspconfig.configs').vtsls = require('vtsls').lspconfig

      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('VtslsKeymap', { clear = true }),
        desc = 'Set vtsls keybindings via which-key',
        callback = function(args)
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          if not client then return end

          if client.name == 'vtsls' then
            local has_wk, wk = pcall(require, 'which-key')
            if has_wk then
              wk.add {
                {
                  '<leader>cV',
                  function() require('vtsls').commands.select_ts_version() end,
                  desc = 'Select workspace TS version',
                  icon = { icon = ' ', color = 'blue' }, -- TypeScript logo
                  buffer = args.buf,
                },
              }
            else
              vim.keymap.set('n', '<leader>cV', function() require('vtsls').commands.select_ts_version() end, {
                buffer = args.buf,
                desc = 'Select workspace TS version',
                silent = true,
              })
            end
          end
        end,
      })
    end,
  },
}
