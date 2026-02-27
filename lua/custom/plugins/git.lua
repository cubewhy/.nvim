return {
  {
    'kdheepak/lazygit.nvim',
    lazy = true,
    cmd = { 'LazyGit', 'LazyGitConfig', 'LazyGitCurrentFile', 'LazyGitFilter', 'LazyGitFilterCurrentFile' },
    dependencies = { 'nvim-lua/plenary.nvim' },
    keys = {
      { '<leader>gg', '<cmd>LazyGit<cr>', desc = 'LazyGit' },
    },
    config = function()
      vim.opt.termguicolors = true
      vim.api.nvim_set_hl(0, 'LazyGitBorder', { fg = 'NONE', bg = 'NONE' })
      vim.api.nvim_set_hl(0, 'LazyGitFloat', { link = 'Normal' })

      vim.g.lazygit_floating_window_winblend = 0 -- transparency of floating window
      vim.g.lazygit_floating_window_scaling_factor = 0.9 -- scaling factor for floating window
      vim.g.lazygit_floating_window_border_chars = { '╭', '─', '╮', '│', '╯', '─', '╰', '│' } -- customize lazygit popup window border characters
      vim.g.lazygit_floating_window_use_plenary = 0 -- use plenary.nvim to manage floating window if available
      vim.g.lazygit_use_neovim_remote = 1 -- fallback to 0 if neovim-remote is not installed

      vim.g.lazygit_on_exit_callback = nil -- optional function callback when exiting lazygit (useful for example to refresh some UI elements after lazy git has made some changes)
    end,
  },
  {
    'lewis6991/gitsigns.nvim',
    lazy = false,
    keys = {
      -- Navigation
      { ']c', function() require('gitsigns').nav_hunk 'next' end, desc = 'Next Git Change' },
      { '[c', function() require('gitsigns').nav_hunk 'prev' end, desc = 'Prev Git Change' },

      -- Hunk Actions
      { '<leader>gs', ':Gitsigns stage_hunk<CR>', mode = { 'n', 'v' }, desc = 'Stage Hunk' },
      { '<leader>gr', ':Gitsigns reset_hunk<CR>', mode = { 'n', 'v' }, desc = 'Reset Hunk' },
      { '<leader>gS', function() require('gitsigns').stage_buffer() end, desc = 'Stage Buffer' },
      { '<leader>gu', function() require('gitsigns').undo_stage_hunk() end, desc = 'Undo Stage Hunk' },
      { '<leader>gR', function() require('gitsigns').reset_buffer() end, desc = 'Reset Buffer' },
      { '<leader>gp', function() require('gitsigns').preview_hunk() end, desc = 'Preview Hunk' },
      { '<leader>gb', function() require('gitsigns').blame_line { full = true } end, desc = 'Blame Line' },
      { '<leader>gd', function() require('gitsigns').diffthis() end, desc = 'Diff Against Index' },
      { '<leader>gD', function() require('gitsigns').diffthis '~' end, desc = 'Diff Against Last Commit' },

      -- Toggles
      { '<leader>ub', function() require('gitsigns').toggle_current_line_blame() end, desc = 'Toggle Git Blame Line' },

      { '<leader>uD', function() require('gitsigns').toggle_deleted() end, desc = 'Toggle Git Deleted' },
    },
  },
  {
    'nvim-telescope/telescope.nvim',
    keys = {
      {
        '<leader>gf',
        function()
          require('telescope.builtin').git_bcommits {
            prompt_title = 'Current File History (Commits)',
          }
        end,
        desc = '[G]it [F]ile History',
      },
    },
  },
}
