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
        local cwd = vim.fn.getcwd()
        if cwd == nil then
          return ''
        end

        local flocation = vim.fn.expand '%:p:h'

        if flocation == cwd then
          return '/'
        end

        -- make sure all the magic characters are no longer magic
        cwd = cwd:gsub('([%(%)%.%%%+%-%*%?%[%^%$])', '%%%1')

        local f = flocation:gsub(cwd, '')
        return f
      end,
    },
  },
}
