return {
  {
    'mason-org/mason.nvim',
    config = true,
    keys = {
      { '<leader>cm', '<cmd>Mason<cr>', desc = 'Mason' },
    },
  },
  {
    'stevearc/aerial.nvim',
    event = { 'BufReadPre', 'BufNewFile' },
    config = function()
      require('aerial').setup {
        on_attach = function(bufnr)
          vim.keymap.set('n', '[[', '<cmd>AerialPrev<cr>', { buffer = bufnr, desc = 'Prev Symbol' })
          vim.keymap.set('n', ']]', '<cmd>AerialNext<cr>', { buffer = bufnr, desc = 'Next Symbol' })
        end,
      }
    end,
  },
  {
    'neovim/nvim-lspconfig',
    event = { 'BufReadPre', 'BufNewFile' },
    dependencies = {
      { 'mason-org/mason.nvim', config = true },
      'mason-org/mason-lspconfig.nvim',
      'WhoIsSethDaniel/mason-tool-installer.nvim',
      'stevearc/aerial.nvim',
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
          mapv('<leader>ca', vim.lsp.buf.code_action, 'Code Action')
          -- map('<leader>cd', vim.diagnostic.open_float, 'Code Diagnostics')

          -- Source Action (Organize Imports etc.)
          mapv('<leader>cA', function() vim.lsp.buf.code_action { context = { only = { 'source' }, diagnostics = {} } } end, 'Code Source Actions')

          local client = vim.lsp.get_client_by_id(event.data.client_id)

          if client ~= nil and client.name == 'vtsls' then
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

          -- Inlay Hints Toggle
          if client and client:supports_method 'textDocument/inlayHint' then
            map('<leader>uh', function() vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf }) end, 'Toggle Inlay Hints')
          end

          if client and client:supports_method 'textDocument/codeLens' then
            map('<leader>cc', vim.lsp.codelens.run, 'Run CodeLens')
            map('<leader>cC', function() vim.lsp.codelens.enable(true, { bufnr = event.buf }) end, 'Refresh CodeLens')

            vim.lsp.codelens.enable(true, { bufnr = event.buf })
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
        -- rust_analyzer = {},
        basedpyright = {},
        -- ty = {},
        -- vtsls = {
        --   settings = {
        --     vtsls = {},
        --     typescript = {},
        --   },
        -- },
        taplo = {},
      }

      require('mason-lspconfig').setup {
        ensure_installed = vim.tbl_keys(servers),
        handlers = {
          function(server_name)
            -- skip rust-analyzer since we manage it via rustacenvim
            if server_name == 'rust_analyzer' or server_name == 'rust-analyzer' then return end

            local server = servers[server_name] or {}
            server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
            require('lspconfig')[server_name].setup(server)
          end,
        },
      }

      -- nixd
      vim.lsp.config('nixd', {
        cmd = { 'nixd' },
        filetypes = { 'nix' },
      })

      vim.lsp.enable 'nixd'
    end,
  },
  {
    'jmbuhr/otter.nvim',
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
    },
    opts = {},
  },
  { -- Autoformat
    'stevearc/conform.nvim',
    event = { 'BufWritePre' },
    cmd = { 'ConformInfo' },
    keys = {
      {
        '<leader>cf',
        function() require('conform').format { async = true, lsp_format = 'fallback' } end,
        mode = '',
        desc = 'Format buffer/selected range',
      },
      {
        '<leader>cF',
        function()
          require('conform').format {
            formatters = { 'injected' },
            timeout_ms = 3000,
          }
        end,
        desc = 'Format Injected Languages',
      },
      {
        '<leader>uf',
        function()
          local is_disabled = not vim.b.disable_autoformat
          vim.b.disable_autoformat = is_disabled

          local b_icon = is_disabled and '󰅙 ' or '󰄬 '

          vim.notify(
            string.format('Buffer Format: %s\n(Global is %s)', is_disabled and 'OFF' or 'ON', vim.g.disable_autoformat and 'OFF' or 'ON'),
            is_disabled and vim.log.levels.WARN or vim.log.levels.INFO,
            { title = 'Formatter', icon = b_icon }
          )
        end,
        desc = 'Toggle format-on-save (buffer)',
      },
      {
        '<leader>uF',
        function()
          local is_disabled = not vim.g.disable_autoformat
          vim.g.disable_autoformat = is_disabled

          local g_icon = is_disabled and '󰅙 ' or '󰄬 '
          local b_status = vim.b.disable_autoformat and 'OFF' or 'ON'

          vim.notify(
            string.format('Global Format: %s\n(Buffer is %s)', is_disabled and 'OFF' or 'ON', b_status),
            is_disabled and vim.log.levels.WARN or vim.log.levels.INFO,
            { title = 'Formatter', icon = g_icon }
          )
        end,
        desc = 'Toggle format-on-save (global)',
      },
    },
    opts = {
      notify_on_error = false,
      format_on_save = function(bufnr)
        if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then return end

        -- Disable "format_on_save lsp_fallback" for languages that don't
        -- have a well standardized coding style. You can add additional
        -- languages here or re-enable it for the disabled ones.
        local disable_filetypes = { c = true, cpp = true }
        if disable_filetypes[vim.bo[bufnr].filetype] then
          return nil
        else
          return {
            timeout_ms = 500,
            lsp_format = 'fallback',
          }
        end
      end,
      formatters_by_ft = {
        lua = { 'stylua' },
        markdown = { 'prettierd', 'injected' },
        sql = { 'sql_formatter' },
        go = { 'goimports' },
        -- Conform can also run multiple formatters sequentially
        -- python = { "isort", "black" },
        --
        -- You can use 'stop_after_first' to run the first available formatter from the list
        javascript = { 'prettierd', stop_after_first = true },
        typescript = { 'prettierd', stop_after_first = true },
        jsx = { 'prettierd', stop_after_first = true },
        vue = { 'prettierd', stop_after_first = true },
        less = { 'prettierd', stop_after_first = true },
        scss = { 'prettierd', stop_after_first = true },
        graphql = { 'prettierd', stop_after_first = true },
        flow = { 'prettierd', stop_after_first = true },
        css = { 'prettierd', stop_after_first = true },
        json = { 'prettierd', stop_after_first = true },
        yaml = { 'prettierd', stop_after_first = true },
        html = { 'prettierd', stop_after_first = true },
        -- nix = { 'alejandra' },
      },
      formatters = {
        injected = {
          -- ignore errors on formatting injected languages
          options = { ignore_errors = true },
        },
      },
    },
  },

  { -- Autocompletion
    'saghen/blink.cmp',
    -- event = 'VimEnter',
    event = 'InsertEnter',
    version = '1.*',
    dependencies = {
      -- Snippet Engine
      {
        'L3MON4D3/LuaSnip',
        version = '2.*',
        build = (function()
          -- Build Step is needed for regex support in snippets.
          -- This step is not supported in many windows environments.
          -- Remove the below condition to re-enable on windows.
          if vim.fn.has 'win32' == 1 or vim.fn.executable 'make' == 0 then return end
          return 'make install_jsregexp'
        end)(),
        dependencies = {
          -- `friendly-snippets` contains a variety of premade snippets.
          --    See the README about individual language/framework/plugin snippets:
          --    https://github.com/rafamadriz/friendly-snippets
          -- {
          --   'rafamadriz/friendly-snippets',
          --   config = function()
          --     require('luasnip.loaders.from_vscode').lazy_load()
          --   end,
          -- },
        },
        opts = {},
      },
    },
    --- @module 'blink.cmp'
    --- @type blink.cmp.Config
    opts = {
      keymap = {
        -- 'default' (recommended) for mappings similar to built-in completions
        --   <c-y> to accept ([y]es) the completion.
        --    This will auto-import if your LSP supports it.
        --    This will expand snippets if the LSP sent a snippet.
        -- 'super-tab' for tab to accept
        -- 'enter' for enter to accept
        -- 'none' for no mappings
        --
        -- For an understanding of why the 'default' preset is recommended,
        -- you will need to read `:help ins-completion`
        --
        -- No, but seriously. Please read `:help ins-completion`, it is really good!
        --
        -- All presets have the following mappings:
        -- <tab>/<s-tab>: move to right/left of your snippet expansion
        -- <c-space>: Open menu or open docs if already open
        -- <c-n>/<c-p> or <up>/<down>: Select next/previous item
        -- <c-e>: Hide menu
        -- <c-k>: Toggle signature help
        --
        -- See :h blink-cmp-config-keymap for defining your own keymap
        preset = 'default',

        -- For more advanced Luasnip keymaps (e.g. selecting choice nodes, expansion) see:
        --    https://github.com/L3MON4D3/LuaSnip?tab=readme-ov-file#keymaps
      },

      appearance = {
        -- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
        -- Adjusts spacing to ensure icons are aligned
        nerd_font_variant = 'mono',
      },

      completion = {
        -- By default, you may press `<c-space>` to show the documentation.
        -- Optionally, set `auto_show = true` to show the documentation after a delay.
        documentation = { auto_show = false, auto_show_delay_ms = 500 },
      },

      sources = {
        default = { 'lsp', 'path', 'snippets' },
      },

      snippets = { preset = 'luasnip' },

      -- Blink.cmp includes an optional, recommended rust fuzzy matcher,
      -- which automatically downloads a prebuilt binary when enabled.
      --
      -- By default, we use the Lua implementation instead, but you may enable
      -- the rust implementation via `'prefer_rust_with_warning'`
      --
      -- See :h blink-cmp-config-fuzzy for more information
      fuzzy = { implementation = 'prefer_rust_with_warning' },

      -- Shows a signature help window while you type arguments for a function
      signature = { enabled = true },
    },
  },
  {
    'smjonas/inc-rename.nvim',
    event = 'BufEnter',
    config = function()
      require('inc_rename').setup {
        -- the name of the command
        cmd_name = 'IncRename',
        -- the highlight group used for highlighting the identifier's new name
        hl_group = 'Substitute',
        -- whether an empty new name should be previewed; if false the command preview will be cancelled instead
        preview_empty_name = false,
        -- whether to display a `Renamed m instances in n files` message after a rename operation
        show_message = true,
        -- whether to save the "IncRename" command in the commandline history (set to false to prevent issues with
        -- navigating to older entries that may arise due to the behavior of command preview)
        save_in_cmdline_history = true,
        -- the type of the external input buffer to use (currently supports "dressing" or "snacks")
        input_buffer_type = nil,
        -- callback to run after renaming, receives the result table (from LSP handler) as an argument
        post_hook = nil,
      }

      require('noice').setup {
        presets = { inc_rename = true },
      }
    end,
  },
  {
    'Wansmer/symbol-usage.nvim',
    enabled = false,
    event = 'BufReadPre',
    config = function()
      local function text_format(symbol)
        local fragments = {}

        -- Indicator that shows if there are any other symbols in the same line
        local stacked_functions = symbol.stacked_count > 0 and (' | +%s'):format(symbol.stacked_count) or ''

        if symbol.references then
          local usage = symbol.references <= 1 and 'usage' or 'usages'
          local num = symbol.references == 0 and 'no' or symbol.references
          table.insert(fragments, ('%s %s'):format(num, usage))
        end

        if symbol.definition then table.insert(fragments, symbol.definition .. ' defs') end

        if symbol.implementation then table.insert(fragments, symbol.implementation .. ' impls') end

        return table.concat(fragments, ', ') .. stacked_functions
      end

      require('symbol-usage').setup {
        text_format = text_format,
      }
    end,
  },
}
