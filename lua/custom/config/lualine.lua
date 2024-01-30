require('lualine').setup {
  options = {
    theme = 'auto',
    icons_enabled = false,
    component_separators = '|',
    section_separators = { left = '', right = '' },
  },
  sections = {
    lualine_x = {
      {
        'filetype',
        on_click = require 'lspconfig.ui.lspinfo',
      },
    },
    lualine_z = {
      function()
        local cwd = vim.fn.getcwd()
        if cwd == nil then
          return ''
        end

        local flocation = vim.fn.expand '%:p:h'

        if flocation == cwd then
          return '/'
        end

        cwd = cwd:gsub('([%(%)%.%%%+%-%*%?%[%^%$])', '%%%1')

        local f = flocation:gsub(cwd, '')
        return f
      end,
    },
  },
}
