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

    -- Useful plugin to show you pending keybinds.
    {
        'folke/which-key.nvim',
        config = function()
            require 'custom.config.which_key'
        end,
    },

    {
        -- Set lualine as statusline
        'nvim-lualine/lualine.nvim',
        -- See `:help lualine.txt`
        config = function()
            require 'custom.config.lualine'
        end,
    },

    {
        'numToStr/Comment.nvim',
        opts = {
            opleader = {
                ---Line-comment keymap
                line = '<leader>/',
            },
        },
    },

    {
        -- Highlight, edit, and navigate code
        'nvim-treesitter/nvim-treesitter',
        dependencies = {
            'nvim-treesitter/nvim-treesitter-textobjects',
        },
        build = ':TSUpdate',
        config = function()
            require 'custom.config.treesitter'
        end,
    },

    {
        'jose-elias-alvarez/null-ls.nvim',
        dependencies = { 'nvim-lua/plenary.nvim' },
    },

    {
        'mfussenegger/nvim-dap',
        dependencies = {
            'williamboman/mason.nvim',
            'jay-babu/mason-nvim-dap.nvim',
            'rcarriga/nvim-dap-ui',
        },
    },

    {
        'jay-babu/mason-null-ls.nvim',
        event = { 'BufReadPre', 'BufNewFile' },
        dependencies = {
            'williamboman/mason.nvim',
            'nvimtools/none-ls.nvim',
        },
    },

    {
        -- Autocompletion
        'hrsh7th/nvim-cmp',
        dependencies = {
            -- Snippet Engine & its associated nvim-cmp source
            'L3MON4D3/LuaSnip',
            'saadparwaiz1/cmp_luasnip',

            -- Adds LSP completion capabilities
            'hrsh7th/cmp-nvim-lsp',
            'hrsh7th/cmp-path',

            -- Adds a number of user-friendly snippets
            'rafamadriz/friendly-snippets',

            'hrsh7th/cmp-cmdline',
            'hrsh7th/cmp-buffer',
        },
        config = function()
            require 'custom.config.cmp'
        end,
    },

    {
        'windwp/nvim-autopairs',
        event = 'InsertEnter',
        opts = {},
    },

    {
        'windwp/nvim-ts-autotag',
        opts = {},
    },

    {
        'roobert/tailwindcss-colorizer-cmp.nvim',
        -- optionally, override the default options:
        opts = { color_square_width = 2 },
    },

    {
        'NvChad/nvim-colorizer.lua',
        opts = {
            filetypes = {
                '*',
                '!markdown', -- disable for markdown
            },
            user_default_options = {
                tailwind = true,
            },
        },
    },

    {
        'chentoast/marks.nvim',
        opts = {
            mappings = {
                next = ']m', -- custom mappings
                prev = '[m',
            },
            force_write_shada = true,
        },
    },

    {
        'lukas-reineke/indent-blankline.nvim',
        main = 'ibl',
        opts = {},
    },

    'mbbill/undotree',

    {
        'kylechui/nvim-surround',
        version = '*', -- Use for stability; omit to use `main` branch for the latest features
        event = 'VeryLazy',
        opts = {},
    },

    'easymotion/vim-easymotion',

    { 'nvim-treesitter/nvim-treesitter-context' },

    {
        'kevinhwang91/nvim-ufo',
        dependencies = { 'kevinhwang91/promise-async' },
        config = function()
            require('ufo').setup {
                provider_selector = function()
                    return { 'treesitter', 'indent' }
                end,
            }
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
}
