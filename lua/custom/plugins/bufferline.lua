return {
  {
    'akinsho/bufferline.nvim',
    lazy = false,
    version = '*',
    dependencies = 'nvim-tree/nvim-web-devicons',
    keys = {
      {
        'H',
        function() require('bufferline').cycle(-vim.v.count1) end,
        desc = 'Prev Buffer (Smart Jump)',
      },
      {
        'L',
        function() require('bufferline').cycle(vim.v.count1) end,
        desc = 'Next Buffer (Smart Jump)',
      },
      { '<leader>bp', '<cmd>BufferLinePick<cr>', desc = 'Buffer Pick' },
      { '<leader>bc', '<cmd>BufferLinePickClose<cr>', desc = 'Pick Close' },
      { '<leader>bo', '<cmd>BufferLineCloseOthers<cr>', desc = 'Close Others' },
      { '<leader>be', '<cmd>BufferLineSortByExtension<cr>', desc = 'Sort by Extension' },
      { '<leader>`', '<cmd>e #<cr>', desc = 'Switch to Other Buffer' },
      { '<leader>bb', '<cmd>e #<cr>', desc = 'Switch to Other Buffer' },
    },
    opts = {
      options = {
        diagnostics = 'nvim_lsp',
        diagnostics_indicator = function(count, level, diagnostics_dict, context)
          local icon = level:match 'error' and ' ' or ' '
          return ' ' .. icon .. count
        end,
        mode = 'buffers',
        offsets = {
          {
            filetype = 'neo-tree',
            text = 'File Explorer',
            highlight = 'Directory',
            text_align = 'left',
          },
        },
      },
    },
  },
  {
    'nvim-mini/mini.bufremove',
    version = false,
    keys = {
      {
        '<leader>bd',
        function() require('mini.bufremove').delete(0, false) end,
        desc = 'Delete Buffer',
      },
    },
    init = function()
      vim.api.nvim_create_autocmd('BufHidden', {
        desc = 'Wipe empty, unmodified buffers when they are hidden',
        callback = function(event)
          local buf = event.buf

          if not vim.api.nvim_buf_is_valid(buf) then return end

          local name = vim.api.nvim_buf_get_name(buf)
          local is_modified = vim.bo[buf].modified
          local buftype = vim.bo[buf].buftype
          local filetype = vim.bo[buf].filetype
          local line_count = vim.api.nvim_buf_line_count(buf)
          local first_line = vim.api.nvim_buf_get_lines(buf, 0, 1, false)[1]

          if name == '' and not is_modified and buftype == '' and filetype == '' and line_count == 1 and first_line == '' then
            vim.schedule(function()
              if vim.api.nvim_buf_is_valid(buf) then vim.api.nvim_buf_delete(buf, { force = true }) end
            end)
          end
        end,
      })
    end,
  },
}
