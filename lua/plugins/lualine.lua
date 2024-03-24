return {
    -- Set lualine as statusline
    'nvim-lualine/lualine.nvim',
    -- See `:help lualine.txt`
    config = function()
        require('lualine').setup {
            options = { -- custom options
                theme = 'tokyonight',
                icons_enabled = false,
                component_separators = '|',
                section_separators = { left = '', right = '' },
            },
            sections = {
                lualine_a = { 'mode' },
                lualine_b = {
                    {
                        'buffers',
                        mode = 1,
                        symbols = {
                            modified = ' ●', -- Text to show when the buffer is modified
                            alternate_file = '', -- Text to show to identify the alternate file
                            directory = '', -- Text to show when the buffer is a directory
                        },
                    },
                },
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
