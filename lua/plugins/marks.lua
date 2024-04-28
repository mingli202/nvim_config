return {
    'chentoast/marks.nvim',
    opts = {
        force_write_shada = true,
    },
    config = function(_, opts)
        require('marks').setup(opts)

        local marks = require 'marks'
        local map = require('util').map

        map('n', '<leader>ml', vim.cmd.marks, { desc = '[M]arks [L]ist' })
        map('n', '<leader>md', marks.delete_line, { desc = '[M]ark [D]elete' })
        map('n', '<leader>mc', function()
            marks.delete_buf()
            vim.cmd 'wshada!'
        end, { desc = '[M]arks [C]ear' })
    end,
}
