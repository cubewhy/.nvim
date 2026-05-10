return {
  {
    'cubewhy/dropbar.nvim',
    branch = 'fix-event',
    dependencies = {
      'nvim-telescope/telescope-fzf-native.nvim',
      build = 'make',
    },
    opts = {
      {
        ['q'] = '<C-w>q',
        ['<Esc>'] = '<C-w>q',
        ['<LeftMouse>'] = function()
          local menu = utils.menu.get_current()
          if not menu then return end
          local mouse = vim.fn.getmousepos()
          local clicked_menu = utils.menu.get { win = mouse.winid }
          -- If clicked on a menu, invoke the corresponding click action,
          -- else close all menus and set the cursor to the clicked window
          if clicked_menu then
            clicked_menu:click_at({ mouse.line, mouse.column - 1 }, nil, 1, 'l')
            return
          end
          utils.menu.exec 'close'
          utils.bar.exec 'update_current_context_hl'
          if vim.api.nvim_win_is_valid(mouse.winid) then vim.api.nvim_set_current_win(mouse.winid) end
        end,
        ['<CR>'] = function()
          local menu = utils.menu.get_current()
          if not menu then return end
          local cursor = vim.api.nvim_win_get_cursor(menu.win)
          local component = menu.entries[cursor[1]]:first_clickable(cursor[2])
          if component then menu:click_on(component, nil, 1, 'l') end
        end,
        ['<MouseMove>'] = function()
          local menu = utils.menu.get_current()
          if not menu then return end
          local mouse = vim.fn.getmousepos()
          if M.opts.menu.hover then utils.menu.update_hover_hl(mouse) end
          if M.opts.menu.preview then utils.menu.update_preview(mouse) end
        end,
        ['i'] = function()
          local menu = utils.menu.get_current()
          if not menu then return end
          menu:fuzzy_find_open()
        end,
      },
    },
    config = function(_, opts)
      require('dropbar').setup(opts)
      local dropbar_api = require 'dropbar.api'
      vim.keymap.set('n', '<leader>;', dropbar_api.pick, { desc = 'Pick symbols in winbar' })
      vim.keymap.set('n', '[;', dropbar_api.goto_context_start, { desc = 'Go to start of current context' })
      vim.keymap.set('n', '];', dropbar_api.select_next_context, { desc = 'Select next context' })
    end,
  },
}
