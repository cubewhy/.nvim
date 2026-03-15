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
    event = 'BufEnter',
    keys = {
      -- Navigation
      { ']g', function() require('gitsigns').nav_hunk 'next' end, desc = 'Next Git Change' },
      { '[g', function() require('gitsigns').nav_hunk 'prev' end, desc = 'Prev Git Change' },

      -- Hunk Actions
      { '<leader>gs', ':Gitsigns stage_hunk<CR>', mode = { 'n', 'v' }, desc = 'Stage Hunk' },
      { '<leader>gr', ':Gitsigns reset_hunk<CR>', mode = { 'n', 'v' }, desc = 'Reset Hunk' },
      { '<leader>gS', function() require('gitsigns').stage_buffer() end, desc = 'Stage Buffer' },
      { '<leader>gR', function() require('gitsigns').reset_buffer() end, desc = 'Reset Buffer' },
      { '<leader>gp', function() require('gitsigns').preview_hunk_inline() end, desc = 'Preview Git Hunk Inline' },
      { '<leader>gP', function() require('gitsigns').preview_hunk() end, desc = 'Preview Hunk' },
      { '<leader>gb', function() require('gitsigns').blame_line { full = true } end, desc = 'Blame Line' },
      { '<leader>gd', function() require('gitsigns').diffthis() end, desc = 'Diff Against Index' },
      { '<leader>gD', function() require('gitsigns').diffthis '~' end, desc = 'Diff Against Last Commit' },

      -- Toggles
      { '<leader>ub', function() require('gitsigns').toggle_current_line_blame() end, desc = 'Toggle Git Blame Line' },
    },
    config = function()
      require('gitsigns').setup {
        signs = {
          add = { text = '┃' },
          change = { text = '┃' },
          delete = { text = '_' },
          topdelete = { text = '‾' },
          changedelete = { text = '~' },
          untracked = { text = '┆' },
        },
        signs_staged = {
          add = { text = '┃' },
          change = { text = '┃' },
          delete = { text = '_' },
          topdelete = { text = '‾' },
          changedelete = { text = '~' },
          untracked = { text = '┆' },
        },
        signs_staged_enable = true,
        signcolumn = true, -- Toggle with `:Gitsigns toggle_signs`
        numhl = false, -- Toggle with `:Gitsigns toggle_numhl`
        linehl = false, -- Toggle with `:Gitsigns toggle_linehl`
        word_diff = false, -- Toggle with `:Gitsigns toggle_word_diff`
        watch_gitdir = {
          follow_files = true,
        },
        auto_attach = true,
        attach_to_untracked = false,
        current_line_blame = true, -- Toggle with `:Gitsigns toggle_current_line_blame`
        current_line_blame_opts = {
          virt_text = true,
          virt_text_pos = 'eol', -- 'eol' | 'overlay' | 'right_align'
          delay = 200,
          ignore_whitespace = false,
          virt_text_priority = 100,
          use_focus = true,
        },
        current_line_blame_formatter = '<author>, <author_time:%R> - <summary>',
        sign_priority = 6,
        update_debounce = 100,
        status_formatter = nil, -- Use default
        max_file_length = 40000, -- Disable if file is longer than this (in lines)
        preview_config = {
          -- Options passed to nvim_open_win
          style = 'minimal',
          relative = 'cursor',
          row = 0,
          col = 1,
        },
      }

      vim.keymap.set({ 'o', 'x' }, 'ih', '<Cmd>Gitsigns select_hunk<CR>')
    end,
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
        desc = 'Git File History',
      },
    },
  },
}
