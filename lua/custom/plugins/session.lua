return {
  {
    'folke/persistence.nvim',
    event = 'BufReadPre', -- this will only start session saving when an actual file was opened
    keys = {
      { '<leader>qs', function() require('persistence').load() end, desc = 'Restore Session' },
      { '<leader>ql', function() require('persistence').load { last = true } end, desc = 'Restore Last Session' },
      { '<leader>qd', function() require('persistence').stop() end, desc = "Don't Save Current Session" },
      { '<leader>qq', '<cmd>qa<cr>', desc = '[Q]uit [Q]all' },
    },
    opts = {
      options = { 'buffers', 'curdir', 'tabpages', 'winsize' },
    },
    config = function(_, opts)
      require('persistence').setup(opts)

      vim.api.nvim_create_autocmd('User', {
        pattern = 'PersistenceSavePre',
        callback = function()
          for _, win in ipairs(vim.api.nvim_list_wins()) do
            local buf = vim.api.nvim_win_get_buf(win)
            if vim.bo[buf].filetype == 'neo-tree' then vim.api.nvim_win_close(win, true) end
          end
        end,
      })
    end,
  },
}
