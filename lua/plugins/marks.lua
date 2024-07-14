return {
    'chentoast/marks.nvim',
    opts = {
        force_write_shada = true,
    },
    config = function(_, opts)
        require('marks').setup(opts)

        local map = require('util').map

        map('n', '<leader>ml', ':MarksQFListAll <CR>', { desc = '[M]arks [L]ist' })
    end,
}
