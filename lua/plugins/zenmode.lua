return {
    'folke/zen-mode.nvim',
    opts = {
        plugins = {
            options = {
                laststatus = 3,
            },
        },
    },
    keys = {
        { '<leader>z', ':ZenMode<CR>', desc = 'zen mode' },
    },
}
