local handler = function(virtText, lnum, endLnum, width, truncate)
  local newVirtText = {}
  local suffix = (' 󰁂 %d '):format(endLnum - lnum)
  local sufWidth = vim.fn.strdisplaywidth(suffix)
  local targetWidth = width - sufWidth
  local curWidth = 0
  for _, chunk in ipairs(virtText) do
    local chunkText = chunk[1]
    local chunkWidth = vim.fn.strdisplaywidth(chunkText)
    if targetWidth > curWidth + chunkWidth then
      table.insert(newVirtText, chunk)
    else
      chunkText = truncate(chunkText, targetWidth - curWidth)
      local hlGroup = chunk[2]
      table.insert(newVirtText, { chunkText, hlGroup })
      chunkWidth = vim.fn.strdisplaywidth(chunkText)
      -- str width returned from truncate() may less than 2nd argument, need padding
      if curWidth + chunkWidth < targetWidth then suffix = suffix .. (' '):rep(targetWidth - curWidth - chunkWidth) end
      break
    end
    curWidth = curWidth + chunkWidth
  end
  table.insert(newVirtText, { suffix, 'MoreMsg' })
  return newVirtText
end

return {
  'kevinhwang91/nvim-ufo',
  event = 'BufReadPost',
  dependencies = {
    'kevinhwang91/promise-async',
  },
  keys = {
    { 'zR', function() require('ufo').openAllFolds() end, desc = 'Open all folds' },
    { 'zM', function() require('ufo').closeAllFolds() end, desc = 'Close all folds' },
    { 'zr', function() require('ufo').openFoldsExceptKinds() end, desc = 'Open folds except kinds' },
    { 'zm', function() require('ufo').closeFoldsWith(0) end, desc = 'Close folds with (0)' },
    {
      'K',
      function()
        local ok_dap, dap = pcall(require, 'dap')
        if ok_dap and dap.session() then
          require('dap.ui.widgets').hover()
          return
        end

        local ok_ufo, ufo = pcall(require, 'ufo')
        local winid = ok_ufo and ufo.peekFoldedLinesUnderCursor() or nil

        if not winid then vim.lsp.buf.hover() end
      end,
      desc = 'Smart Hover (DAP > UFO > LSP)',
    },
  },
  config = function()
    -- vim.o.foldcolumn = '1'
    vim.o.foldlevel = 99
    vim.o.foldlevelstart = 99
    vim.o.foldenable = true

    -- enable folding for lsp servers
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities.textDocument.foldingRange = {
      dynamicRegistration = false,
      lineFoldingOnly = true,
    }
    local language_servers = vim.lsp.get_clients()
    for _, ls in ipairs(language_servers) do
      vim.lsp.config(ls, {
        capabilities = capabilities,
        -- you can add other fields for setting up lsp server in this table
      })
    end
    require('ufo').setup {
      fold_virt_text_handler = handler,
      provider_selector = function(bufnr, filetype, buftype) return { 'treesitter', 'indent' } end,
    }
  end,
}
