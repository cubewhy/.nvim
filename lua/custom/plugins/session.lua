return {
  {
    'folke/persistence.nvim',
    event = 'BufReadPre', -- this will only start session saving when an actual file was opened
    keys = {
      { '<leader>qs', function() require('persistence').load() end,               desc = 'Re[s]tore Session' },
      { '<leader>qS', function() require('persistence').select() end,             desc = '[S]elect Session' },
      { '<leader>ql', function() require('persistence').load { last = true } end, desc = 'Restore [L]ast Session' },
      { '<leader>qd', function() require('persistence').stop() end,               desc = "[D]on't Save Current Session" },
      { '<leader>qq', '<cmd>qa<cr>',                                              desc = '[Q]uit all' },
    },
    opts = {
      options = { 'buffers', 'curdir', 'tabpages', 'winsize' },
    },
    config = function(_, opts)
      require('persistence').setup(opts)

      vim.api.nvim_create_autocmd('User', {
        pattern = 'PersistenceSavePre',
        callback = function()
          local ok_dapui, dapui = pcall(require, "dapui")
          if ok_dapui then dapui.close() end

          local ok_neotree, neotree = pcall(require, "neo-tree.command")
          if ok_neotree then neotree.execute({ action = "close" }) end

          for _, win in ipairs(vim.api.nvim_list_wins()) do
            local buf = vim.api.nvim_win_get_buf(win)
            if vim.bo[buf].buftype == 'terminal' then
              vim.api.nvim_win_close(win, true)
            end
          end
        end,
      })
    end,
  },
}
