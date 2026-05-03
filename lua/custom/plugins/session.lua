return {
  {
    'folke/persistence.nvim',
    event = 'BufReadPre', -- this will only start session saving when an actual file was opened
    keys = {
      { '<leader>qs', function() require('persistence').load() end, desc = 'Restore Session' },
      { '<leader>qS', function() require('persistence').select() end, desc = 'Select Session' },
      { '<leader>ql', function() require('persistence').load { last = true } end, desc = 'Restore Last Session' },
      { '<leader>qd', function() require('persistence').stop() end, desc = "Don't Save Current Session" },
      { '<leader>qq', '<cmd>qa<cr>', desc = 'Quit all' },
    },
    opts = {
      options = { 'buffers', 'curdir', 'tabpages', 'winsize' },
    },
    config = function(_, opts)
      require('persistence').setup(opts)

      vim.api.nvim_create_autocmd('User', {
        pattern = 'PersistenceSavePre',
        callback = function()
          local ok_dapui, dapui = pcall(require, 'dapui')
          if ok_dapui then dapui.close() end

          local ok_neotree, neotree = pcall(require, 'neo-tree.command')
          if ok_neotree then neotree.execute { action = 'close' } end

          -- close quickfix list
          vim.cmd 'cclose'
          -- close location list
          vim.cmd 'lclose'

          for _, win in ipairs(vim.api.nvim_list_wins()) do
            local buf = vim.api.nvim_win_get_buf(win)

            -- close neotest buf
            if vim.bo[buf].filetype:find 'neotest' then vim.api.nvim_win_close(win, true) end

            -- close terminals
            if vim.bo[buf].buftype == 'terminal' then vim.api.nvim_win_close(win, true) end
          end
        end,
      })
    end,
  },
}
