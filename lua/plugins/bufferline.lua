return {
    'akinsho/bufferline.nvim',
    config = function()
        local bufferline = require 'bufferline'
        bufferline.setup {
            options = {
                separator_style = 'thick',
                indicator = {
                    icon = '|',
                    style = 'icon',
                },
                show_buffer_icons = false, -- disable filetype icons for buffers
                show_buffer_close_icons = false,
                themable = true,
                diagnostics = 'nvim_lsp',
            },
        }
    end,
    version = '*',
    dependencies = 'nvim-tree/nvim-web-devicons',
}
