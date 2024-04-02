-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information
return {

    { 'nvim-tree/nvim-web-devicons', opts = {} },
    -- NOTE: First, some plugins that don't require any configuration

    -- Git related plugins
    'tpope/vim-fugitive',
    'tpope/vim-rhubarb',

    -- Detect tabstop and shiftwidth automatically
    'tpope/vim-sleuth',

    {
        'numToStr/Comment.nvim',
        opts = {},
    },

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
        'chentoast/marks.nvim',
        opts = {
            force_write_shada = true,
        },
    },

    {
        'lukas-reineke/indent-blankline.nvim',
        main = 'ibl',
        opts = {},
    },

    'mbbill/undotree',

    'easymotion/vim-easymotion',

    { 'nvim-treesitter/nvim-treesitter-context', opts = { max_lines = 5 } },

    {
        'kevinhwang91/nvim-ufo',
        dependencies = { 'kevinhwang91/promise-async' },
        opts = {},
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

    {
        'Exafunction/codeium.nvim',
        dependencies = {
            'nvim-lua/plenary.nvim',
            'hrsh7th/nvim-cmp',
        },
        opts = {},
    },

    {
        'Wansmer/treesj',
        dependencies = { 'nvim-treesitter/nvim-treesitter' },
        opts = { use_default_keymaps = false },
    },

    {
        'folke/trouble.nvim',
        dependencies = { 'nvim-tree/nvim-web-devicons' },
        opts = {},
    },
}
