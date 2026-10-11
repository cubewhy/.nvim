return {
  {
    'mason-org/mason.nvim',
    config = true,
    keys = {
      { '<leader>cm', '<cmd>Mason<cr>', desc = 'Mason' },
    },
  },
  {
    'neovim/nvim-lspconfig',
    event = { 'BufReadPre', 'BufNewFile' },
    dependencies = {
      { 'mason-org/mason.nvim', config = true },
      'b0o/schemastore.nvim',
      'mason-org/mason-lspconfig.nvim',
      'WhoIsSethDaniel/mason-tool-installer.nvim',
    },
    config = function()
      -- Capabilities (Blink.cmp & UFO)
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      if pcall(require, 'blink.cmp') then capabilities = require('blink.cmp').get_lsp_capabilities(capabilities) end
      capabilities.textDocument.foldingRange = { dynamicRegistration = false, lineFoldingOnly = true }

      -- LspAttach Keymaps
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('user-lsp-attach', { clear = true }),
        callback = function(event)
          local map = function(keys, func, desc) vim.keymap.set('n', keys, func, { buffer = event.buf, desc = desc }) end
          local mapv = function(keys, func, desc) vim.keymap.set({ 'n', 'v' }, keys, func, { buffer = event.buf, desc = desc }) end

          vim.keymap.set('n', '<leader>cr', function() return ':IncRename ' .. vim.fn.expand '<cword>' end, { expr = true, desc = 'Rename Symbol' })
          mapv('<leader>ca', vim.lsp.buf.code_action, 'Code Actions')
          map('<leader>cd', vim.diagnostic.open_float, 'Code Diagnostics')

          -- Source Action (Organize Imports etc.)
          mapv('<leader>cA', function() vim.lsp.buf.code_action { context = { only = { 'source' }, diagnostics = {} } } end, 'Source Actions')

          local client = vim.lsp.get_client_by_id(event.data.client_id)

          if client then
            if client.name == 'vtsls' or client.name == 'ruff' then
              map(
                '<leader>co',
                function()
                  vim.lsp.buf.code_action {
                    context = {
                      only = { 'source.organizeImports' },
                      diagnostics = {},
                    },
                    apply = true,
                  }
                end,
                'Organize Imports'
              )
            end

            if client.name == 'vtsls' then
              map('<leader>cu', function()
                vim.lsp.buf.code_action {
                  context = {
                    ---@diagnostic disable-next-line: assign-type-mismatch
                    only = { 'source.removeUnused' },
                    diagnostics = {},
                  },
                  apply = true,
                }
              end, 'Remove Unused Imports')
            end

            if client:supports_method 'textDocument/codeLens' then
              map('<leader>cc', vim.lsp.codelens.run, 'Run CodeLens')
              map('<leader>cC', function() vim.lsp.codelens.enable(true, { bufnr = event.buf }) end, 'Refresh CodeLens')
            end
          end

          -- enable inlay_hint by default
          vim.lsp.inlay_hint.enable(true, { bufnr = event.buf })
        end,
      })

      -- Mason & Server Setup
      local servers = {
        lua_ls = {
          settings = {
            Lua = { completion = { callSnippet = 'Replace' }, diagnostics = { globals = { 'vim' } } },
          },
        },
        basedpyright = {
          settings = {
            basedpyright = {
              analysis = {
                diagnosticSeverityOverrides = {
                  reportUnusedImport = 'none',
                  reportUnusedCallResult = 'none',
                  reportUnknownVariableType = 'none',
                  reportUnknownMemberType = 'none',
                  reportUnknownArgumentType = 'none',
                  reportUnannotatedClassAttribute = 'none',
                  reportOptionalMemberAccess = 'warning',
                },
              },
            },
          },
        },
        jsonls = {
          settings = {
            json = {
              schemas = require('schemastore').json.schemas(),
              validate = { enable = true },
            },
          },
        },
        yamlls = {
          settings = {
            yaml = {
              schemaStore = {
                -- You must disable built-in schemaStore support if you want to use
                -- this plugin and its advanced options like `ignore`.
                enable = false,
                -- Avoid TypeError: Cannot read properties of undefined (reading 'length')
                url = '',
              },
              schemas = require('schemastore').yaml.schemas(),
            },
          },
        },
        tombi = {},
        ruff = {},
        bashls = {},
        docker_language_server = {},
        clangd = {},
        docker_compose_language_service = {},
        cssls = {},
        html = {},
        neocmake = {},
        gopls = {},
        typos_lsp = {},
        vtsls = {},
        lemminx = {
          settings = {
            xml = {
              catalogs = {
                vim.fn.expand '~/.config/xml/catalog.xml',
              },
            },
          },
        },
      }

      -- Servers that installed externally
      local ext_servers = {
        nil_ls = {},
      }

      require('mason-lspconfig').setup {
        ensure_installed = vim.tbl_keys(servers),
        automatic_enable = false,
      }

      local all_servers = vim.tbl_extend('force', servers, ext_servers)

      for name, server in pairs(all_servers) do
        local config = vim.deepcopy(server)

        config.capabilities = vim.tbl_deep_extend('force', {}, capabilities, config.capabilities or {})

        vim.lsp.config(name, config)
        vim.lsp.enable(name)
      end
    end,
  },
  {
    'jmbuhr/otter.nvim',
    ft = { 'markdown', 'norg', 'quarto' },
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
    },
    opts = {},
  },
}
