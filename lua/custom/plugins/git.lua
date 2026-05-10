return {
  {
    'folke/snacks.nvim',
    keys = {
      {
        '<leader>gg',
        function()
          ---@type fun(opts?: snacks.lazygit.Config): snacks.win
          Snacks.lazygit()
        end,
        desc = 'LazyGit',
      },
      { '<leader>gh', function() Snacks.lazygit.log() end, desc = 'Git History' },
      { '<leader>gf', function() Snacks.lazygit.log_file() end, desc = 'Git History' },
      { '<leader>gx', function() Snacks.gitbrowse() end, desc = 'Open In Browser' },
    },
    ---@type snacks.Config
    opts = {
      ---@class snacks.lazygit.Config: snacks.terminal.Opts
      ---@field args? string[]
      ---@field theme? snacks.lazygit.Theme
      lazygit = {
        -- automatically configure lazygit to use the current colorscheme
        -- and integrate edit with the current neovim instance
        configure = true,
        -- extra configuration for lazygit that will be merged with the default
        -- snacks does NOT have a full yaml parser, so if you need `"test"` to appear with the quotes
        -- you need to double quote it: `"\"test\""`
        config = {
          os = { editPreset = 'nvim-remote' },
          gui = {
            -- set to an empty string "" to disable icons
            nerdFontsVersion = '3',
          },
        },
        theme_path = vim.fs.normalize(vim.fn.stdpath 'cache' .. '/lazygit-theme.yml'),
        -- Theme for lazygit
        theme = {
          [241] = { fg = 'Special' },
          activeBorderColor = { fg = 'MatchParen', bold = true },
          cherryPickedCommitBgColor = { fg = 'Identifier' },
          cherryPickedCommitFgColor = { fg = 'Function' },
          defaultFgColor = { fg = 'Normal' },
          inactiveBorderColor = { fg = 'FloatBorder' },
          optionsTextColor = { fg = 'Function' },
          searchingActiveBorderColor = { fg = 'MatchParen', bold = true },
          selectedLineBgColor = { bg = 'Visual' }, -- set to `default` to have no background colour
          unstagedChangesColor = { fg = 'DiagnosticError' },
        },
        win = {
          style = 'lazygit',
        },
      },
      ---@class snacks.gitbrowse.Config
      gitbrowse =
        ---@field url_patterns? table<string, table<string, string|fun(fields:snacks.gitbrowse.Fields):string>>
        {
          notify = true, -- show notification on open
          -- Handler to open the url in a browser
          ---@param url string
          open = function(url)
            if vim.fn.has 'nvim-0.10' == 0 then
              require('lazy.util').open(url, { system = true })
              return
            end
            vim.ui.open(url)
          end,
          ---@type "repo" | "branch" | "file" | "commit" | "permalink"
          what = 'commit', -- what to open. not all remotes support all types
          commit = nil, ---@type string?
          branch = nil, ---@type string?
          line_start = nil, ---@type number?
          line_end = nil, ---@type number?
          -- patterns to transform remotes to an actual URL
          remote_patterns = {
            { '^(https?://.*)%.git$', '%1' },
            { '^git@(.+):(.+)%.git$', 'https://%1/%2' },
            { '^git@(.+):(.+)$', 'https://%1/%2' },
            { '^git@(.+)/(.+)$', 'https://%1/%2' },
            { '^org%-%d+@(.+):(.+)%.git$', 'https://%1/%2' },
            { '^ssh://git@(.*)$', 'https://%1' },
            { '^ssh://([^:/]+)(:%d+)/(.*)$', 'https://%1/%3' },
            { '^ssh://([^/]+)/(.*)$', 'https://%1/%2' },
            { 'ssh%.dev%.azure%.com/v3/(.*)/(.*)$', 'dev.azure.com/%1/_git/%2' },
            { '^https://%w*@(.*)', 'https://%1' },
            { '^git@(.*)', 'https://%1' },
            { ':%d+', '' },
            { '%.git$', '' },
          },
          url_patterns = {
            ['github%.com'] = {
              branch = '/tree/{branch}',
              file = '/blob/{branch}/{file}#L{line_start}-L{line_end}',
              permalink = '/blob/{commit}/{file}#L{line_start}-L{line_end}',
              commit = '/commit/{commit}',
            },
            ['gitlab%.com'] = {
              branch = '/-/tree/{branch}',
              file = '/-/blob/{branch}/{file}#L{line_start}-{line_end}',
              permalink = '/-/blob/{commit}/{file}#L{line_start}-{line_end}',
              commit = '/-/commit/{commit}',
            },
            ['bitbucket%.org'] = {
              branch = '/src/{branch}',
              file = '/src/{branch}/{file}#lines-{line_start}-L{line_end}',
              permalink = '/src/{commit}/{file}#lines-{line_start}-L{line_end}',
              commit = '/commits/{commit}',
            },
            ['git.sr.ht'] = {
              branch = '/tree/{branch}',
              file = '/tree/{branch}/item/{file}',
              permalink = '/tree/{commit}/item/{file}#L{line_start}',
              commit = '/commit/{commit}',
            },
          },
        },
    },
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
}
