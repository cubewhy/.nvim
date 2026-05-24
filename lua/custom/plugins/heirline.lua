return {
  {
    'rebelot/heirline.nvim',
    event = 'BufEnter',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      vim.opt.showtabline = 2

      local utils = require 'heirline.utils'

      local colors = {
        bg = utils.get_highlight('Normal').bg,
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

      local TablineFileDiagnostics = {
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
          local full_path = vim.api.nvim_buf_get_name(self.bufnr)
          if full_path == '' then return '[No Name]' end

          local filename = vim.fn.fnamemodify(full_path, ':t')

          local all_bufs = vim.tbl_filter(
            function(b) return b ~= self.bufnr and vim.api.nvim_buf_is_loaded(b) and vim.bo[b].buflisted end,
            vim.api.nvim_list_bufs()
          )

          local duplicates = {}
          for _, b in ipairs(all_bufs) do
            if vim.fn.fnamemodify(vim.api.nvim_buf_get_name(b), ':t') == filename then
              table.insert(duplicates, vim.fn.fnamemodify(vim.api.nvim_buf_get_name(b), ':.'))
            end
          end

          if #duplicates == 0 then return filename end

          local current_rel_path = vim.fn.fnamemodify(full_path, ':.')
          local current_parts = vim.split(current_rel_path, '/', { trimempty = true })

          local start_idx = 1
          for i = 1, #current_parts - 1 do
            local is_common = true
            for _, other_path in ipairs(duplicates) do
              local other_parts = vim.split(other_path, '/', { trimempty = true })
              if other_parts[i] ~= current_parts[i] then
                is_common = false
                break
              end
            end
            if not is_common then
              start_idx = i
              break
            end
          end

          local result = {}
          for i = start_idx, #current_parts do
            local part = current_parts[i]
            if i == start_idx or i == #current_parts then
              table.insert(result, part)
            else
              local short = part:sub(1, 1)
              if short == '.' then short = part:sub(1, 2) end
              table.insert(result, short)
            end
          end

          return table.concat(result, '/')
        end,
        hl = function(self) return { bold = self.is_active, italic = false } end,
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

      local TablineFileFlags = {
        {
          condition = function(self) return vim.api.nvim_get_option_value('modified', { buf = self.bufnr }) end,
          provider = ' [+]',
          hl = { fg = 'orange' },
        },
        {
          condition = function(self)
            return not vim.api.nvim_get_option_value('modifiable', { buf = self.bufnr }) or vim.api.nvim_get_option_value('readonly', { buf = self.bufnr })
          end,
          provider = function(self)
            if vim.api.nvim_get_option_value('buftype', { buf = self.bufnr }) == 'terminal' then
              return '  '
            else
              return ''
            end
          end,
          hl = { fg = 'orange' },
        },
      }

      local TablineFileNameBlock = {
        init = function(self) self.filename = vim.api.nvim_buf_get_name(self.bufnr) end,
        hl = function(self)
          if self.is_active then
            return 'TabLineSel'
          -- why not?
          -- elseif not vim.api.nvim_buf_is_loaded(self.bufnr) then
          --     return { fg = "gray" }
          else
            return 'TabLine'
          end
        end,
        on_click = {
          callback = function(_, minwid, _, button)
            if button == 'm' then -- close on mouse middle click
              vim.schedule(function() vim.api.nvim_buf_delete(minwid, { force = false }) end)
            else
              vim.api.nvim_win_set_buf(0, minwid)
            end
          end,
          minwid = function(self) return self.bufnr end,
          name = 'heirline_tabline_buffer_callback',
        },
        TablineFileIcon,
        TablineFileName,
        TablineFileFlags,
        TablineFileDiagnostics,
      }

      local TablineBufferBlock = utils.surround({ '', '' }, function(self)
        if self.is_active then
          return utils.get_highlight('TabLineSel').bg
        else
          return utils.get_highlight('TabLine').bg
        end
      end, { TablineFileNameBlock })

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

      local BufferLine = utils.make_buflist(TablineBufferBlock, { provider = '', hl = { fg = 'gray' } }, { provider = '', hl = { fg = 'gray' } })

      local TablineTab = {
        provider = function(self)
          -- Simple padding around the tab number
          return ' %' .. self.tabnr .. 'T ' .. self.tabnr .. ' %T '
        end,
        hl = function(self) return self.is_active and 'TabLineSel' or 'TabLine' end,
      }

      local Tabpage = {
        provider = function(self) return '%' .. self.tabnr .. 'T ' .. self.tabpage .. ' %T' end,
        hl = function(self)
          if not self.is_active then
            return 'TabLine'
          else
            return 'TabLineSel'
          end
        end,
      }

      local TabpageClose = {
        provider = '%999X  %X',
        hl = 'TabLine',
      }

      local TabPages = {
        -- only show this component if there's 2 or more tabpages
        condition = function() return #vim.api.nvim_list_tabpages() >= 2 end,
        { provider = '%=' },
        utils.make_tablist(Tabpage),
        TabpageClose,
      }

      require('heirline').load_colors(colors)
      require('heirline').setup {
        tabline = { TablineOffset, BufferLine, { provider = '%=' }, TabPages },
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
}
