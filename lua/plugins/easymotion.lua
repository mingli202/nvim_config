return {
    'easymotion/vim-easymotion',
    config = function()
        local map = require('util').map
        map('n', '<leader><leader>s', '<Plug>(easymotion-s2)', { desc = '[L]eap, easymotion search 2 char' })
        map('n', '<leader><leader>/', '<Plug>(easymotion-sn)', { desc = 'easymotion search 2 char' })

        vim.g.EasyMotion_smartcase = 1
    end,
}
