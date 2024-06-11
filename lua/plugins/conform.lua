return {
    'stevearc/conform.nvim',
    dependencies = { 'mason.nvim' },
    config = function()
        require('conform').setup {
            formatters_by_ft = {
                lua = { 'stylua' },

                javascript = { 'prettierd' },
                typescript = { 'prettierd' },
                javascriptreact = { 'prettierd' },
                typescriptreact = { 'prettierd' },
                vue = { 'prettierd' },
                css = { 'prettierd' },
                scss = { 'prettierd' },
                less = { 'prettierd' },
                html = { 'prettierd' },

                json = { 'jq' },

                cs = { 'csharpier' },

                c = { 'clang-format' },
                cpp = { 'clang-format' },
                arduino = { 'clang-format' },

                rust = { 'rustfmt' },

                python = { 'black' },
                sh = { 'shfmt' },
                zsh = { 'shfmt' },
            },

            format_on_save = {
                timeout_ms = 3000,
                lsp_fallback = true, -- not recommended to change
            },
        }
    end,
}
