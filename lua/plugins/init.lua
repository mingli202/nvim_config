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

    -- {
    --     'supermaven-inc/supermaven-nvim',
    --     config = function()
    --         require('supermaven-nvim').setup {
    --             keymaps = {
    --                 accept_suggestion = '<C-l>',
    --                 clear_suggestion = '<C-]>',
    --                 accept_word = '<C-j>',
    --             },
    --         }
    --     end,
    -- },
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
    --     'kevinhwang91/nvim-ufo',
    --     dependencies = { 'kevinhwang91/promise-async', 'mason-org/mason-lspconfig.nvim' },
    --     config = function()
    --         vim.keymap.set('n', 'zR', require('ufo').openAllFolds)
    --         vim.keymap.set('n', 'zM', require('ufo').closeAllFolds)
    --
    --         -- folding
    --         -- Persist folds (and optionally the cursor) per file.
    --         vim.opt.viewoptions = { 'folds', 'cursor' }
    --
    --         local fold_view_group = vim.api.nvim_create_augroup('PersistFolds', {
    --             clear = true,
    --         })
    --
    --         vim.api.nvim_create_autocmd('BufWinLeave', {
    --             group = fold_view_group,
    --             pattern = '?*',
    --             callback = function(args)
    --                 -- Do not create views for terminals, plugin windows, unnamed buffers, etc.
    --                 if vim.bo[args.buf].buftype == '' and vim.api.nvim_buf_get_name(args.buf) ~= '' then
    --                     vim.cmd 'silent! mkview'
    --                 end
    --             end,
    --         })
    --
    --         vim.api.nvim_create_autocmd('BufWinEnter', {
    --             group = fold_view_group,
    --             pattern = '?*',
    --             callback = function(args)
    --                 if vim.bo[args.buf].buftype == '' and vim.api.nvim_buf_get_name(args.buf) ~= '' then
    --                     vim.cmd 'silent! loadview'
    --                 end
    --             end,
    --         })
    --
    --         require('ufo').setup()
    --     end,
    -- },

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
