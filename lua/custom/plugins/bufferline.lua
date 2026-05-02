return {
  {
    'rebelot/heirline.nvim',
    event = 'BufEnter',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      vim.opt.showtabline = 2

      local utils = require 'heirline.utils'

      local colors = {
        bright_bg = utils.get_highlight('Folded').bg,
        bright_fg = utils.get_highlight('Folded').fg,
        red = utils.get_highlight('DiagnosticError').fg,
        dark_red = utils.get_highlight('DiffDelete').bg,
        green = utils.get_highlight('String').fg,
        blue = utils.get_highlight('Function').fg,
        gray = utils.get_highlight('NonText').fg,
        orange = utils.get_highlight('Constant').fg,
        purple = utils.get_highlight('Statement').fg,
        cyan = utils.get_highlight('Special').fg,
        diag_warn = utils.get_highlight('DiagnosticWarn').fg,
        diag_error = utils.get_highlight('DiagnosticError').fg,
        diag_hint = utils.get_highlight('DiagnosticHint').fg,
        diag_info = utils.get_highlight('DiagnosticInfo').fg,
        git_del = utils.get_highlight('diffDeleted').fg,
        git_add = utils.get_highlight('diffAdded').fg,
        git_change = utils.get_highlight('diffChanged').fg,
      }

      vim.diagnostic.config {
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = ' ',
            [vim.diagnostic.severity.WARN] = ' ',
            [vim.diagnostic.severity.INFO] = '󰋇 ',
            [vim.diagnostic.severity.HINT] = '󰌵',
          },
        },
      }

      local Diagnostics = {
        condition = function(self) return #vim.diagnostic.get(self.bufnr) > 0 end,

        -- Fetching custom diagnostic icons
        static = {
          error_icon = vim.diagnostic.config()['signs']['text'][vim.diagnostic.severity.ERROR],
          warn_icon = vim.diagnostic.config()['signs']['text'][vim.diagnostic.severity.WARN],
          info_icon = vim.diagnostic.config()['signs']['text'][vim.diagnostic.severity.INFO],
          hint_icon = vim.diagnostic.config()['signs']['text'][vim.diagnostic.severity.HINT],
        },

        -- If you defined custom LSP diagnostics with vim.fn.sign_define(), use this instead
        -- Note defining custom LSP diagnostic this way its deprecated, though
        --static = {
        --    error_icon = vim.fn.sign_getdefined("DiagnosticSignError")[1].text,
        --    warn_icon = vim.fn.sign_getdefined("DiagnosticSignWarn")[1].text,
        --    info_icon = vim.fn.sign_getdefined("DiagnosticSignInfo")[1].text,
        --    hint_icon = vim.fn.sign_getdefined("DiagnosticSignHint")[1].text,
        --},

        init = function(self)
          self.errors = #vim.diagnostic.get(self.bufnr, { severity = vim.diagnostic.severity.ERROR })
          self.warnings = #vim.diagnostic.get(self.bufnr, { severity = vim.diagnostic.severity.WARN })
          self.hints = #vim.diagnostic.get(self.bufnr, { severity = vim.diagnostic.severity.HINT })
          self.info = #vim.diagnostic.get(self.bufnr, { severity = vim.diagnostic.severity.INFO })
        end,

        update = { 'DiagnosticChanged', 'BufEnter' },

        {
          provider = ' ',
        },
        {
          provider = function(self)
            -- 0 is just another output, we can decide to print it or not!
            return self.errors > 0 and (self.error_icon .. self.errors .. ' ')
          end,
          hl = { fg = 'diag_error' },
        },
        {
          provider = function(self) return self.warnings > 0 and (self.warn_icon .. self.warnings .. ' ') end,
          hl = { fg = 'diag_warn' },
        },
        {
          provider = function(self) return self.info > 0 and (self.info_icon .. self.info .. ' ') end,
          hl = { fg = 'diag_info' },
        },
        {
          provider = function(self) return self.hints > 0 and (self.hint_icon .. self.hints) end,
          hl = { fg = 'diag_hint' },
        },
        {
          provider = ' ',
        },
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
        Diagnostics,
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

      require('heirline').load_colors(colors)
      require('heirline').setup {
        tabline = { TablineOffset, BufferLine },
      }
    end,
    keys = {
      {
        'H',
        function() vim.cmd(vim.v.count1 .. 'bprevious') end,
        desc = 'Prev Buffer',
      },
      {
        'L',
        function() vim.cmd(vim.v.count1 .. 'bnext') end,
        desc = 'Next Buffer',
      },
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
