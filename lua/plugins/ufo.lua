return {
    'kevinhwang91/nvim-ufo',
    dependencies = { 'kevinhwang91/promise-async' },
    config = function()
        require('ufo').setup()

        local ufo = require 'ufo'
        local map = require('util').map
        map('n', 'zR', ufo.openAllFolds, { desc = 'folds: open all' })
        map('n', 'zM', ufo.closeAllFolds, { desc = 'folds: close all' })
    end,
}
