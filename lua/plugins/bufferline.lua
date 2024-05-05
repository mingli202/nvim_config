return {
    'akinsho/bufferline.nvim',
    config = function()
        local bufferline = require 'bufferline'
        bufferline.setup {
            options = {
                separator_style = { '', '' },
                indicator = {
                    style = 'none',
                },
                show_buffer_icons = false, -- disable filetype icons for buffers
                show_buffer_close_icons = false,
            },
        }
    end,
    version = '*',
    dependencies = 'nvim-tree/nvim-web-devicons',
}
