return {
    'folke/trouble.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
        local trouble = require 'trouble'
        trouble.setup {}

        local map = require('util').map

        map('n', '<leader>tt', trouble.toggle, { desc = '[T]oggle [T]rouble' })
        map('n', '<leader>tl', function()
            trouble.toggle 'loclist'
        end, { desc = '[T]rouble [L]ocation list' })
        map('n', '<leader>tq', function()
            trouble.toggle 'quickfix'
        end, { desc = '[T]rouble [Q]uickfix list' })
        map('n', ']t', function()
            trouble.next { skip_groups = true, jump = true }
        end, { desc = 'trouble next' })
        map('n', '[t', function()
            trouble.previous { skip_groups = true, jump = true }
        end, { desc = 'trouble previous' })

        map('n', '<leader>td', function()
            trouble.toggle 'document_diagnostics'
        end, { desc = '[T]rouble [D]ocument diagnostics' })
        map('n', '<leader>tw', function()
            trouble.toggle 'document_diagnostics'
        end, {
            desc = '[T]rouble [W]orkspace diagnostics',
        })
    end,
}
