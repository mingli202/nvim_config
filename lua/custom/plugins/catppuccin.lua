return {
  -- Theme
  'catppuccin/nvim',
  priority = 1000,
  name = 'catppuccin',
  lazy = false,
  config = function()
    require('catppuccin').setup {
      transparent_background = true,
    }
    vim.cmd.colorscheme 'catppuccin'
  end,
}
