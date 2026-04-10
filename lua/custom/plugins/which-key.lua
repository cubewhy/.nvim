return {
  'folke/which-key.nvim',
  event = 'VimEnter',
  opts = {
    delay = 0,
    icons = { mappings = vim.g.have_nerd_font },
    preset = 'helix',
  },
  config = function(_, opts)
    local wk = require 'which-key'
    wk.setup(opts)

    local function toggle_icon(condition)
      if condition then
        return { icon = ' ', color = 'green' }
      else
        return { icon = ' ', color = 'red' }
      end
    end

    wk.add {
      -- categories
      { '<leader>g', group = 'Git', icon = { icon = ' ', color = 'orange' }, mode = { 'n', 'v' } },
      { '<leader>q', group = 'Quit / Session', icon = { icon = '󰈆 ', color = 'red' } },
      { '<leader>s', group = 'Search', icon = { icon = ' ', color = 'cyan' }, mode = { 'n', 'v' } },
      { '<leader>f', group = 'Find', icon = { icon = ' ', color = 'cyan' }, mode = { 'n', 'v' } },
      { '<leader>t', group = 'Test', icon = { icon = '󰙨 ', color = 'yellow' } },
      { '<leader>x', group = 'Diagnostics', icon = { icon = '󱖫 ', color = 'red' } },
      { '<leader>n', group = 'Notifications', icon = { icon = '󰵅 ', color = 'blue' } },

      { '<leader>l', '<cmd>Lazy<cr>', desc = 'Lazy.nvim', icon = { icon = '󰒲 ', color = 'azure' } },

      -- buffers
      { '<leader>b', group = 'Buffer', icon = { icon = '󰓩 ', color = 'green' } },
      { 'H', '<cmd>BufferLineCyclePrev<cr>', desc = 'Prev Buffer', icon = { icon = ' ', color = 'cyan' } },
      { 'L', '<cmd>BufferLineCycleNext<cr>', desc = 'Next Buffer', icon = { icon = ' ', color = 'cyan' } },
      { '<leader>bc', '<cmd>BufferLinePickClose<cr>', desc = 'Pick Close', icon = { icon = '󰅙 ', color = 'red' } },
      { '<leader>bd', desc = 'Delete Buffer', icon = { icon = '󰆴', color = 'red' } },
      { '<leader>be', '<cmd>BufferLineSortByExtension<cr>', desc = 'Sort by Extension', icon = { icon = '󰒺 ', color = 'yellow' } },
      { '<leader>bp', '<cmd>BufferLinePick<cr>', desc = 'Buffer Pick', icon = { icon = '󰢷 ', color = 'purple' } },
      { '<leader>bb', '<cmd>e #<cr>', desc = 'Switch to Other Buffer', icon = { icon = '󰈔', color = 'green' } },
      { '<leader>`', '<cmd>e #<cr>', desc = 'Switch to Other Buffer', icon = { icon = '󰈔', color = 'green' } },

      -- code
      { '<leader>c', group = 'Code', icon = { icon = ' ', color = 'blue' }, mode = { 'n', 'v' } },
      { '<leader>cr', desc = 'Rename', icon = { icon = ' ', color = 'blue' } },
      { '<leader>cf', mode = 'v', desc = 'Format Selected', icon = { icon = '󰈔 ', color = 'cyan' } },
      { '<leader>cf', mode = 'n', desc = 'Format Buffer', icon = { icon = '󰈔 ', color = 'cyan' } },

      -- Session
      { '<leader>q', group = 'Quit / Session', icon = '󰦛 ' },
      { '<leader>qq', icon = { icon = '󰗼 ', color = 'red' }, desc = 'Quit All' },
      { '<leader>qs', icon = { icon = '󰦛 ', color = 'green' }, desc = 'Restore Session' },
      { '<leader>ql', icon = { icon = '󰦛 ', color = 'cyan' }, desc = 'Restore Last Session' },
      { '<leader>qd', icon = { icon = '󰅙 ', color = 'red' }, desc = 'Stop Saving Session' },

      -- window
      { '<leader>w', group = 'Window', icon = { icon = ' ', color = 'purple' } },
      { '<leader>w-', '<C-w>s', desc = 'Split Below', icon = { icon = ' ', color = 'purple' } },
      { '<leader>w|', '<C-w>v', desc = 'Split Right', icon = { icon = ' ', color = 'purple' } },
      { '<leader>wd', '<C-w>c', desc = 'Close Window', icon = { icon = '󰅙 ', color = 'red' } },
      { '<leader>ww', '<C-w>w', desc = 'Switch Window', icon = { icon = ' ', color = 'purple' } },
      { '<leader>wh', '<C-w>h', desc = 'Move to Left', icon = { icon = ' ', color = 'purple' } },
      { '<leader>wj', '<C-w>j', desc = 'Move Down', icon = { icon = ' ', color = 'purple' } },
      { '<leader>wk', '<C-w>k', desc = 'Move Up', icon = { icon = ' ', color = 'purple' } },
      { '<leader>wl', '<C-w>l', desc = 'Move to Right', icon = { icon = ' ', color = 'purple' } },
      { '<leader>wo', '<C-w>o', desc = 'Close Others', icon = { icon = ' ', color = 'red' } },
      { '<leader>w=', '<C-w>=', desc = 'Equalize Size', icon = { icon = '󰦪 ', color = 'purple' } },
      { '<leader>w>', '<cmd>vertical resize +5<cr>', desc = 'Increase Width', icon = { icon = '󰁔 ', color = 'purple' } },
      { '<leader>w<', '<cmd>vertical resize -5<cr>', desc = 'Decrease Width', icon = { icon = '󰁍 ', color = 'purple' } },
      { '<leader>-', '<C-w>s', desc = 'Split Below', icon = { icon = ' ', color = 'purple' } },
      { '<leader>|', '<C-w>v', desc = 'Split Right', icon = { icon = ' ', color = 'purple' } },

      -- window navigations
      { '<C-h>', '<C-w><C-h>', desc = 'Window Left', icon = { icon = ' ', color = 'purple' } },
      { '<C-l>', '<C-w><C-l>', desc = 'Window Right', icon = { icon = ' ', color = 'purple' } },
      { '<C-j>', '<C-w><C-j>', desc = 'Window Down', icon = { icon = ' ', color = 'purple' } },
      { '<C-k>', '<C-w><C-k>', desc = 'Window Up', icon = { icon = ' ', color = 'purple' } },

      -- tabs
      { '<leader><TAB>', group = 'Tabs', icon = { icon = '󰓩 ', color = 'green' } },
      { '<leader><TAB><TAB>', '<cmd>tabnew<cr>', desc = 'New Tab' },
      { '<leader><TAB>d', '<cmd>tabclose<cr>', desc = 'Close Tab' },
      { '<leader><TAB>o', '<cmd>tabonly<cr>', desc = 'Close Other Tabs' },
      { '<leader><TAB>l', '<cmd>tabnext<cr>', desc = 'Next Tab' },
      { '<leader><TAB>h', '<cmd>tabprevious<cr>', desc = 'Previous Tab' },

      -- debugger
      { '<leader>d', group = 'Debug', icon = { icon = '󰃤 ', color = 'red' } },
      { '<leader>fd', group = 'Debugger', icon = { icon = '󰃤 ', color = 'red' }, mode = { 'n', 'v' } },

      -- ui toggles
      {
        '<leader>u',
        group = 'UI',
        icon = { icon = '󰙵 ', color = 'azure' },
        expand = function()
          local bufnr = vim.api.nvim_get_current_buf()

          local has_inlay_hints = false
          local has_codelens = false

          for _, client in ipairs(vim.lsp.get_clients { bufnr = bufnr }) do
            if client.server_capabilities.inlayHintProvider then has_inlay_hints = true end
            if client.server_capabilities.codeLensProvider then has_codelens = true end
          end

          local tsc_ok, tsc = pcall(require, 'treesitter-context')
          local tsc_enabled = tsc_ok and tsc.enabled()

          return {
            {
              'f',

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
              desc = 'Autoformat (Buffer)',
              icon = toggle_icon(not vim.b.disable_autoformat),
            },
            {
              'F',

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

              desc = 'Autoformat (Global)',
              icon = toggle_icon(not vim.g.disable_autoformat),
            },
            {
              'd',
              function() vim.diagnostic.enable(not vim.diagnostic.is_enabled { bufnr = bufnr }) end,
              desc = 'Toggle Diagnostics',
              icon = toggle_icon(vim.diagnostic.is_enabled { bufnr = bufnr }),
            },
            {
              'h',
              function()
                if vim.lsp.inlay_hint then vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = bufnr }) end
              end,
              desc = 'Toggle Inlay Hints',
              cond = has_inlay_hints,
              icon = toggle_icon(vim.lsp.inlay_hint and vim.lsp.inlay_hint.is_enabled { bufnr = bufnr }),
            },
            {
              'c',
              function()
                if vim.lsp.codelens then vim.lsp.codelens.enable(not vim.lsp.codelens.is_enabled { bufnr = bufnr }) end
              end,
              desc = 'Toggle Codelens',
              cond = has_codelens,
              icon = toggle_icon(vim.lsp.codelens and vim.lsp.codelens.is_enabled { bufnr = bufnr }),
            },
            {
              'w',
              function() vim.wo.wrap = not vim.wo.wrap end,
              desc = 'Toggle Line Wrap',
              icon = toggle_icon(vim.wo.wrap),
            },
            {
              'T',
              function()
                if vim.treesitter.highlighter.active[bufnr] then
                  vim.treesitter.stop(bufnr)
                  vim.notify('Treesitter Highlighting: OFF', vim.log.levels.WARN)
                else
                  vim.treesitter.start(bufnr)
                  vim.notify('Treesitter Highlighting: ON', vim.log.levels.INFO)
                end
              end,
              desc = 'Toggle Treesitter Highlight',
              icon = toggle_icon(vim.treesitter.highlighter.active[bufnr] ~= nil),
            },
            {
              't',
              function()
                if tsc_ok then tsc.toggle() end
              end,
              desc = 'Toggle Treesitter Context',
              icon = toggle_icon(tsc_enabled),
            },
            {
              'b',
              function() require('gitsigns').toggle_current_line_blame() end,
              desc = 'Toggle Git blame line',
              icon = toggle_icon(require('gitsigns.config').config.current_line_blame),
            },
          }
        end,
      },
    }
  end,
}
