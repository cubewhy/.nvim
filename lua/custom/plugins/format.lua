return {
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
    },
    opts = {
      notify_on_error = false,
      format_on_save = function(bufnr)
        if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then return end

        -- Disable "format_on_save lsp_fallback" for languages that don't
        -- have a well standardized coding style. You can add additional
        -- languages here or re-enable it for the disabled ones.
        local disable_filetypes = {}
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
        sql = { 'sqlfluff' },
        go = { 'goimports' },
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
        nix = { 'nixfmt' },
      },
      formatters = {
        injected = {
          -- ignore errors on formatting injected languages
          options = { ignore_errors = true },
        },
      },
    },
  },
}
