return {
    -- Set lualine as statusline
    'nvim-lualine/lualine.nvim',
    -- See `:help lualine.txt`
    config = function()
        require('lualine').setup {
            options = { -- custom options
                theme = 'auto',
                icons_enabled = false,
                component_separators = '|',
                section_separators = { left = '', right = '' },
            },
            sections = {
                lualine_a = { 'mode' },
                lualine_b = {},
                lualine_c = { {
                    'filename',
                    path = 1,
                } },
                lualine_x = {
                    'diagnostics',
                },
                lualine_y = {
                    'diff',
                    'branch',
                },
                lualine_z = {
                    'progress',
                },
            },
        }
    end,
}
