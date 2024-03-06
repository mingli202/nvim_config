return {
    'jose-elias-alvarez/null-ls.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
        local null_ls = require 'null-ls'

        null_ls.setup {
            sources = {
                null_ls.builtins.diagnostics.eslint_d,
                null_ls.builtins.formatting.stylua,
                null_ls.builtins.formatting.prettierd,
                null_ls.builtins.formatting.clang_format.with {
                    extra_filetypes = { 'arduino' },
                    disabled_filetypes = { 'cs' },
                },
                null_ls.builtins.formatting.black,
                null_ls.builtins.formatting.csharpier.with {
                    extra_args = { '--config-path', '/Users/vincentliu/.csharperrc.json' },
                },

                -- check spelling for only markdown
                null_ls.builtins.diagnostics.cspell.with {
                    filetypes = { 'markdown', 'norg' },
                },
                null_ls.builtins.code_actions.cspell.with {
                    filetypes = { 'markdown', 'norg' },
                },

                -- null_ls.builtins.formatting.rustfmt,
            },
            -- make root_dir = cwd
            root_dir = function()
                return nil
            end,
        }
    end,
}
