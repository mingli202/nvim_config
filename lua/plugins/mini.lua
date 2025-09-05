return { -- Collection of various small independent plugins/modules
    'echasnovski/mini.nvim',
    config = function()
        require('mini.ai').setup { n_lines = 500 }
        require('mini.surround').setup()
        require('mini.pairs').setup()
        require('mini.files').setup {
            use_as_default_explorer = true,
            windows = {
                preview = true,
            },
            mappings = {
                go_in = '',
                go_in_plus = '<CR>',
                go_out = '-',
                go_out_plus = '',
            },
        }

        local map = require('util').map

        map('n', '<leader>o', function()
            MiniFiles.open(vim.api.nvim_buf_get_name(0), false)
        end)
    end,
}
