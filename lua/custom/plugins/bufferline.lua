return {
  {
    'rebelot/heirline.nvim',
    event = 'BufEnter',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      vim.opt.showtabline = 2

      local utils = require 'heirline.utils'

      local colors = {
        bright_orange = utils.get_highlight('DiagnosticWarn').fg,
        red = utils.get_highlight('DiagnosticError').fg,
        dark_red = utils.get_highlight('DiffDelete').fg,
        gray = utils.get_highlight('NonText').fg,
        bg = utils.get_highlight('TabLine').bg,
        tabline_sel_bg = utils.get_highlight('TabLineSel').bg,
        tabline_sel_fg = utils.get_highlight('TabLineSel').fg,
      }

      local TablineBufnr = {
        provider = function(self) return tostring(self.bufnr) .. '. ' end,
        hl = 'Comment',
      }

      local TablineFileName = {
        provider = function(self)
          local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(self.bufnr), ':t')
          return filename == '' and '[No Name]' or filename
        end,
        hl = function(self) return { bold = self.is_active or self.is_visible, italic = false } end,
      }

      local TablineFileIcon = {
        init = function(self)
          local filename = vim.api.nvim_buf_get_name(self.bufnr)
          local extension = vim.fn.fnamemodify(filename, ':e')
          self.icon, self.icon_color = require('nvim-web-devicons').get_icon_color(filename, extension, { default = true })
        end,
        provider = function(self) return self.icon and (self.icon .. ' ') end,
        hl = function(self) return { fg = self.icon_color } end,
      }

      local TablineModifiedIndicator = {
        condition = function(self) return vim.api.nvim_get_option_value('modified', { buf = self.bufnr }) end,
        provider = ' [+]',
        hl = { fg = colors.bright_orange },
      }

      local TablineBufferBlock = {
        { provider = '  ' },
        TablineFileIcon,
        TablineFileName,
        TablineModifiedIndicator,
        { provider = '  ' },
        hl = function(self)
          if self.is_active then
            return 'TabLineSel'
          else
            return 'TabLine'
          end
        end,
      }

      local TablineOffset = {
        condition = function(self)
          local win = vim.api.nvim_tabpage_list_wins(0)[1]
          local bufnr = vim.api.nvim_win_get_buf(win)
          self.winid = win
          if vim.bo[bufnr].filetype == 'neo-tree' then
            self.title = 'File Explorer'
            return true
          end
        end,
        provider = function(self)
          local width = vim.api.nvim_win_get_width(self.winid)
          return string.rep(' ', width)
        end,
        hl = { bg = colors.bg },
      }

      local BufferLine = require('heirline.utils').make_buflist(
        TablineBufferBlock,
        { provider = ' ', hl = { bg = colors.bg } },
        { provider = ' ', hl = { bg = colors.bg } }
      )

      require('heirline').setup {
        tabline = { TablineOffset, BufferLine },
      }
    end,
    keys = {
      { 'H', '<cmd>bprevious<cr>', desc = 'Prev Buffer' },
      { 'L', '<cmd>bnext<cr>', desc = 'Next Buffer' },
      { '<leader>`', '<cmd>e #<cr>', desc = 'Switch to Other Buffer' },
    },
  },
  {
    'nvim-mini/mini.nvim',
    version = false,
    keys = {
      {
        '<leader>bd',
        function() require('mini.bufremove').delete(0, false) end,
        desc = 'Delete Buffer',
      },
      {
        '<leader>bo',
        function()
          local current = vim.api.nvim_get_current_buf()
          local bufs = vim.api.nvim_list_bufs()
          for _, buf in ipairs(bufs) do
            if vim.api.nvim_buf_is_valid(buf) and vim.bo[buf].buflisted and buf ~= current then require('mini.bufremove').delete(buf, false) end
          end
        end,
        desc = 'Close Other Buffers',
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
    config = function() require('mini.bufremove').setup {} end,
  },
}
