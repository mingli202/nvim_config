-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information
return {
    {
        'nvim-tree/nvim-web-devicons',
        opts = {},
    },
    -- NOTE: First, some plugins that don't require any configuration

    -- Git related plugins
    'tpope/vim-fugitive',
    'tpope/vim-rhubarb',

    -- Detect tabstop and shiftwidth automatically
    'tpope/vim-sleuth',

    {
        'windwp/nvim-autopairs',
        event = 'InsertEnter',
        opts = {},
    },

    {
        'windwp/nvim-ts-autotag',
        opts = {},
        ft = { 'html', 'javascriptreact', 'typescriptreact' },
    },

    {
        'lukas-reineke/indent-blankline.nvim',
        main = 'ibl',
        opts = {
            exclude = {
                filetypes = { 'dashboard' },
            },
        },
    },

    {
        'easymotion/vim-easymotion',
        config = function()
            local map = require('util').map
            map('n', '<leader><leader>l', '<Plug>(easymotion-s2)', { desc = '[L]eap, easymotion search 2 char' })
            map('n', '<leader><leader>/', '<Plug>(easymotion-sn)', { desc = 'easymotion search 2 char' })

            vim.g.EasyMotion_smartcase = 1
        end,
    },

    {
        'christoomey/vim-tmux-navigator',
        cmd = {
            'TmuxNavigateLeft',
            'TmuxNavigateDown',
            'TmuxNavigateUp',
            'TmuxNavigateRight',
            'TmuxNavigatePrevious',
        },
        keys = {
            { '<c-h>', '<cmd><C-U>TmuxNavigateLeft<cr>' },
            { '<c-j>', '<cmd><C-U>TmuxNavigateDown<cr>' },
            { '<c-k>', '<cmd><C-U>TmuxNavigateUp<cr>' },
            { '<c-l>', '<cmd><C-U>TmuxNavigateRight<cr>' },
            { '<c-\\>', '<cmd><C-U>TmuxNavigatePrevious<cr>' },
        },
        lazy = false,
    },

    { 'folke/todo-comments.nvim', opts = {} },

    {
        'Eandrju/cellular-automaton.nvim',
        event = 'VeryLazy',
    },

    'folke/trouble.nvim',
}
