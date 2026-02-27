return {
  {
    'kevinhwang91/nvim-hlslens',
    event = 'BufReadPost',
    config = function()
      require('hlslens').setup()

      local kopts = { noremap = true, silent = true }
      vim.api.nvim_set_keymap('n', 'n', [[<Cmd>execute('normal! ' . v:count1 . 'n')<CR><Cmd>lua require('hlslens').start()<CR>]], kopts)
      vim.api.nvim_set_keymap('n', 'N', [[<Cmd>execute('normal! ' . v:count1 . 'N')<CR><Cmd>lua require('hlslens').start()<CR>]], kopts)
      vim.api.nvim_set_keymap('n', '*', [[*<Cmd>lua require('hlslens').start()<CR>]], kopts)
      vim.api.nvim_set_keymap('n', '#', [[#<Cmd>lua require('hlslens').start()<CR>]], kopts)
      vim.api.nvim_set_keymap('n', 'g*', [[g*<Cmd>lua require('hlslens').start()<CR>]], kopts)
      vim.api.nvim_set_keymap('n', 'g#', [[g#<Cmd>lua require('hlslens').start()<CR>]], kopts)
    end,
  },
  {
    'nvim-lualine/lualine.nvim',
    event = 'VeryLazy',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    opts = function()
      local function format_status()
        if vim.g.disable_autoformat or vim.b.disable_autoformat then return '󰉶 FORMATTER OFF' end
        return ''
      end

      return {
        options = {
          theme = 'auto',
          globalstatus = false,
          disabled_filetypes = { statusline = { 'dashboard', 'alpha', 'neo-tree' } },
        },
        sections = {
          lualine_a = {
            { 'mode', right_padding = 2 },
          },
          lualine_b = {
            { 'branch', icon = '' },
            { 'diff', symbols = { added = ' ', modified = '󰝤 ', removed = ' ' } },
          },
          lualine_c = {
            { 'filetype', icon_only = true, separator = '', padding = { left = 1, right = 0 } },
            { 'filename', path = 1, symbols = { modified = '  ', readonly = ' 󰖭 ', unnamed = ' [No Name] ' } },
          },
          lualine_x = {
            {
              require('noice').api.status.mode.get,
              cond = require('noice').api.status.mode.has,
              color = { fg = '#ff9e64' },
            },
            {
              format_status,
              color = function() return { fg = (vim.g.disable_autoformat or vim.b.disable_autoformat) and '#ff5555' or '#50fa7b' } end,
            },
            {
              'diagnostics',
              sources = { 'nvim_diagnostic' },
              symbols = { error = ' ', warn = ' ', info = ' ', hint = '󰌶 ' },
            },
            -- {
            --   function()
            --     local msg = 'No LSP'
            --     local buf_ft = vim.api.nvim_get_option_value('filetype', { buf = 0 })
            --     local clients = vim.lsp.get_clients { bufnr = 0 }
            --     if next(clients) == nil then return msg end
            --     for _, client in ipairs(clients) do
            --       local filetypes = client.config.filetypes
            --       if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 then return '' end
            --     end
            --     return msg
            --   end,
            --   icon = ' LSP:',
            --   color = { fg = '#ffffff', gui = 'bold' },
            -- },
          },
          lualine_y = { 'progress' },
          lualine_z = {
            { 'location', left_padding = 2 },
          },
        },
        inactive_sections = {
          lualine_a = {},
          lualine_b = {},
          lualine_c = { 'filename' },
          lualine_x = { 'location' },
          lualine_y = {},
          lualine_z = {},
        },
      }
    end,
  },
}
