return {
  'akinsho/bufferline.nvim',
  lazy = false,
  version = '*',
  dependencies = 'nvim-tree/nvim-web-devicons',
  keys = {
    { 'H', '<cmd>BufferLineCyclePrev<cr>', desc = 'Prev Buffer' },
    { 'L', '<cmd>BufferLineCycleNext<cr>', desc = 'Next Buffer' },
    { '<leader>bp', '<cmd>BufferLinePick<cr>', desc = 'Buffer Pick' },
    { '<leader>bc', '<cmd>BufferLinePickClose<cr>', desc = 'Pick Close' },
    { '<leader>bo', '<cmd>BufferLineCloseOthers<cr>', desc = '[C]lose [O]thers' },
    { '<leader>be', '<cmd>BufferLineSortByExtension<cr>', desc = 'Sort by Extension' },
    { '<leader>bd', '<cmd>bdelete<cr>', desc = 'Delete Buffer' },
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
}
