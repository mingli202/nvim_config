return {
    'mbbill/undotree',
    config = function()
        local map = require('util').map
        map('n', '<leader>u', ':UndotreeToggle <CR>', { desc = '[U]ndo tree' })
    end,
}
