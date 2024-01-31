require('lualine').setup {
  options = { -- custom options
    theme = 'auto',
    icons_enabled = false,
    component_separators = '|',
    section_separators = { left = '', right = '' },
  },
  sections = {
    lualine_x = {
      'encoding',
      'fileformat',
      {
        'filetype',
        on_click = require 'lspconfig.ui.lspinfo', -- opens the null-ls info window
      },
    },
    lualine_z = {
      -- removed line number
      -- custom function that gets current file location relative to cwd
      function()
        return vim.fn.expand '%:h'
      end,
    },
  },
}
