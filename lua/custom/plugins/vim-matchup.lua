return {
  'andymass/vim-matchup',
  init = function()
    vim.g.matchup_matchparen_enabled = 1
    vim.g.matchup_matchparen_deferred = 1
    vim.g.matchup_matchparen_hi_delay = 100
    vim.g.matchup_matchparen_offscreen = { method = 'popup' }
    vim.g.matchup_treesitter = 1
  end,
}
