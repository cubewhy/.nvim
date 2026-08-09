return {
  {
    'kevinhwang91/nvim-hlslens',
    event = 'BufReadPost',
    config = function()
      require('hlslens').setup()

      local kopts = { noremap = true, silent = true }
      vim.keymap.set('n', 'n', function()
        local key = vim.v.searchforward == 1 and 'n' or 'N'
        vim.cmd(string.format('normal! %s%szv', vim.v.count1, key))
        require('hlslens').start()
      end, kopts)

      vim.keymap.set('n', 'N', function()
        local key = vim.v.searchforward == 1 and 'N' or 'n'
        vim.cmd(string.format('normal! %s%szv', vim.v.count1, key))
        require('hlslens').start()
      end, kopts)

      local map = vim.keymap.set
      map({ 'x', 'o' }, 'n', "'Nn'[v:searchforward]", { expr = true, desc = 'Next Search Result' })
      map({ 'x', 'o' }, 'N', "'nN'[v:searchforward]", { expr = true, desc = 'Prev Search Result' })
      local opts = function(desc) return vim.tbl_extend('force', kopts, { desc = desc }) end

      map('n', '*', [[*<Cmd>lua require('hlslens').start()<CR>]], opts 'Search word forward')
      map('n', '#', [[#<Cmd>lua require('hlslens').start()<CR>]], opts 'Search word backward')
      map('n', 'g*', [[g*<Cmd>lua require('hlslens').start()<CR>]], opts 'Search partial word forward')
      map('n', 'g#', [[g#<Cmd>lua require('hlslens').start()<CR>]], opts 'Search partial word backward')
    end,
  },
}
