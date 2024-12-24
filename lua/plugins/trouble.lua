return {
    'folke/trouble.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    cmd = 'Trouble',
    keys = {
        {
            '<leader>d',
            '<cmd>Trouble diagnostics toggle<cr>',
            desc = '[D]iagnotics list',
        },
        {
            '<leader>tl',
            '<cmd>Trouble loclist toggle<cr>',
            desc = '[T]rouble [L]ocation list',
        },
        {
            '<leader>tq',
            '<cmd>Trouble quickfix toggle<cr>',
            desc = '[T]rouble [Q]uickfix list',
        },
    },
    config = function()
        local trouble = require 'trouble'
        trouble.setup {}

        local map = require('util').map

        map('n', ']t', function()
            trouble.next(trouble.open 'diagnostics', {})
        end, { desc = 'trouble next' })

        map('n', '[t', function()
            trouble.prev(trouble.open 'diagnostics', {})
        end, { desc = 'trouble previous' })
    end,
}
