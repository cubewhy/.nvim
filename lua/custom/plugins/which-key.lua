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
      { '<leader>b', group = '[B]uffer', icon = { icon = '󰓩 ', color = 'green' } },
      { '<leader>d', group = '[D]ebug', icon = { icon = '󰃤', color = 'red' } },
      { '<leader>c', group = '[C]ode', icon = { icon = ' ', color = 'blue' } },
      { '<leader>g', group = '[G]it', icon = { icon = ' ', color = 'orange' } },
      { '<leader>q', group = '[Q]uit / Session', icon = { icon = '󰈆 ', color = 'red' } },
      { '<leader>s', group = '[S]earch', icon = { icon = ' ', color = 'cyan' } },
      { '<leader>t', group = '[T]erminal', icon = { icon = ' ', color = 'yellow' } },
      { '<leader>w', group = '[W]indow', icon = { icon = ' ', color = 'purple' } },
      { '<leader>x', group = '[D]iagnostics', icon = { icon = '󱖫 ', color = 'red' } },
      { '<leader>u', group = '[U]I Toggles', icon = { icon = '󰙵 ', color = 'azure' } },
      { '<leader>g', group = '[G]it', icon = { icon = ' ', color = 'orange' } },
      { '<leader>n', group = '[N]otifications', icon = { icon = '󰵅 ', color = 'blue' } },

      -- buffers
      { 'H', '<cmd>BufferLineCyclePrev<cr>', desc = 'Prev Buffer', icon = { icon = ' ', color = 'cyan' } },
      { 'L', '<cmd>BufferLineCycleNext<cr>', desc = 'Next Buffer', icon = { icon = ' ', color = 'cyan' } },
      { '<leader>bc', '<cmd>BufferLinePickClose<cr>', desc = 'Pick Close', icon = { icon = '󰅙 ', color = 'red' } },
      { '<leader>bd', '<cmd>bdelete<cr>', desc = 'Delete Buffer', icon = { icon = '󰆴 ', color = 'red' } },
      { '<leader>be', '<cmd>BufferLineSortByExtension<cr>', desc = 'Sort by Extension', icon = { icon = '󰒺 ', color = 'yellow' } },
      { '<leader>bp', '<cmd>BufferLinePick<cr>', desc = 'Buffer Pick', icon = { icon = '󰢷 ', color = 'purple' } },
      { '<leader>bb', '<cmd>e #<cr>', desc = 'Switch to Other Buffer', icon = { icon = '󰈔', color = 'green' } },
      { '<leader>`', '<cmd>e #<cr>', desc = 'Switch to Other Buffer', icon = { icon = '󰈔', color = 'green' } },

      -- Session
      { '<leader>q', group = '[Q]uit / Session', icon = '󰦛 ' },
      { '<leader>qq', icon = { icon = '󰗼 ', color = 'red' }, desc = 'Quit All' },
      { '<leader>qs', icon = { icon = '󰦛 ', color = 'green' }, desc = 'Restore Session' },
      { '<leader>ql', icon = { icon = '󰦛 ', color = 'cyan' }, desc = 'Restore Last Session' },
      { '<leader>qd', icon = { icon = '󰅙 ', color = 'red' }, desc = 'Stop Saving Session' },

      -- window
      { '<leader>w', group = '[W]indow', icon = { icon = ' ', color = 'purple' } },
      { '<leader>w-', '<C-w>s', desc = 'Split Below', icon = { icon = ' ', color = 'purple' } },
      { '<leader>w|', '<C-w>v', desc = 'Split Right', icon = { icon = ' ', color = 'purple' } },
      { '<leader>wd', '<C-w>c', desc = 'Close Window', icon = { icon = '󰅙 ', color = 'red' } },
      { '<leader>ww', '<C-w>w', desc = 'Switch Window', icon = { icon = ' ', color = 'purple' } },
      { '<leader>wh', '<C-w>h', desc = 'Move to Left', icon = { icon = ' ', color = 'purple' } },
      { '<leader>wj', '<C-w>j', desc = 'Move Down', icon = { icon = ' ', color = 'purple' } },
      { '<leader>wk', '<C-w>k', desc = 'Move Up', icon = { icon = ' ', color = 'purple' } },
      { '<leader>wl', '<C-w>l', desc = 'Move to Right', icon = { icon = ' ', color = 'purple' } },
      { '<leader>wo', '<C-w>o', desc = 'Close Others', icon = { icon = '󰭖 ', color = 'red' } },
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

      -- file operations
      { '<C-s>', '<cmd>w<cr><esc>', mode = { 'n', 'i', 'v' }, desc = 'Save File', icon = { icon = '󰆓 ', color = 'green' } },
      { '<C-a>', '<cmd>wa<cr><esc>', mode = { 'n', 'i', 'v' }, desc = 'Save All', icon = { icon = '󰆓 ', color = 'orange' } },

      -- ui toggles
      {
        '<leader>ub',
        desc = 'Git Blame Line',
        icon = function()
          local gs = package.loaded['gitsigns']
          local status = gs and gs.config and gs.config.current_line_blame
          return toggle_icon(status)
        end,
      },
      {
        '<leader>uD',
        desc = 'Git Show Deleted',
        icon = function()
          local gs = package.loaded['gitsigns']
          local status = gs and gs.config and gs.config.show_deleted
          return toggle_icon(status)
        end,
      },
      {
        '<leader>uf',
        desc = 'Autoformat (Buffer)',
        icon = function() return toggle_icon(not vim.b.disable_autoformat) end,
      },
      {
        '<leader>uF',
        desc = 'Autoformat (Global)',
        icon = function() return toggle_icon(not vim.g.disable_autoformat) end,
      },

      {
        '<leader>ud',
        function() vim.diagnostic.enable(not vim.diagnostic.is_enabled()) end,
        desc = 'Diagnostics',
        icon = function() return toggle_icon(vim.diagnostic.is_enabled()) end,
      },
      {
        '<leader>uh',
        function()
          if vim.lsp.inlay_hint then vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled {}) end
        end,
        desc = 'Inlay Hints',
        icon = function() return toggle_icon(vim.lsp.inlay_hint and vim.lsp.inlay_hint.is_enabled {}) end,
      },
      {
        '<leader>uw',
        function() vim.wo.wrap = not vim.wo.wrap end,
        desc = 'Line Wrap',
        icon = function() return toggle_icon(vim.wo.wrap) end,
      },
    }
  end,
}
