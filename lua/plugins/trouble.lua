return {
    'folke/trouble.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
        local trouble = require 'trouble'
        trouble.setup {}

        local map = require('util').map

        map('n', '<leader>d', function()
            trouble.toggle 'diagnostics'
        end, { desc = '[D]iagnotics list' })

        map('n', '<leader>tl', function()
            trouble.toggle 'loclist'
        end, { desc = '[T]rouble [L]ocation list' })

        map('n', '<leader>tq', function()
            trouble.toggle 'quickfix'
        end, { desc = '[T]rouble [Q]uickfix list' })

        map('n', ']t', function()
            trouble.next(trouble.open 'diagnostics', {})
        end, { desc = 'trouble next' })

        map('n', '[t', function()
            trouble.prev(trouble.open 'diagnostics', {})
        end, { desc = 'trouble previous' })
    end,
}
