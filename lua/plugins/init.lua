return {
    'tpope/vim-sleuth', -- Detect tabstop and shiftwidth automatically
    'tpope/vim-fugitive',

    { 'folke/todo-comments.nvim', event = 'VimEnter', dependencies = { 'nvim-lua/plenary.nvim' }, opts = { signs = false } },

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

    {
        'windwp/nvim-autopairs',
        event = 'InsertEnter',
        opts = {},
        -- use opts = {} for passing setup options
        -- this is equivalent to setup({}) function
    },
    {
        'windwp/nvim-ts-autotag',
        event = 'InsertEnter',
        opts = {},
        dependencies = { 'nvim-treesitter/nvim-treesitter' },
    },

    -- {
    --     'mfussenegger/nvim-jdtls',
    --     ft = { 'java' },
    --     config = function()
    --         vim.api.nvim_create_user_command('JdtJunitTest', function()
    --             local jdtls = require 'jdtls'
    --             jdtls.test_class()
    --         end, { desc = 'run junit tests' })
    --     end,
    -- },

    {
        'mbbill/undotree',
        keys = {
            { '<leader>u', '<cmd>UndotreeToggle<cr>' },
        },
    },
}
