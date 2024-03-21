return {
    {
        'rust-lang/rust.vim',
        ft = 'rust',
        init = function()
            vim.g.rustfmt_autosave = 1
            vim.g.rustfmt_fail_silently = 1
        end,
    },

    {
        'simrat39/rust-tools.nvim',
        ft = 'rust',
        config = function()
            require('rust-tools').setup {
                server = {
                    capabilities = require('util').capabilities,
                    on_attach = require('util').on_attach,
                    root_dir = function()
                        return vim.fn.getcwd()
                    end,
                },
                dap = {},
            }
        end,
    },
}
