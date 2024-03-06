return {
    {
        'rust-lang/rust.vim',
        ft = 'rust',
        init = function()
            vim.g.rustfmt_autosave = 1
        end,
    },

    {
        'simrat39/rust-tools.nvim',
        ft = 'rust',
        config = function()
            require('rust-tools').setup {
                server = {
                    capabilities = require('custom.util').capabilities,
                    on_attach = require('custom.util').on_attach,
                },
            }
        end,
    },
}
