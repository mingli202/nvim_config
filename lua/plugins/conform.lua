return {
    'stevearc/conform.nvim',
    config = function()
        require('conform').setup {
            notify_on_error = false,
            formatters_by_ft = {
                lua = { 'stylua' },

                javascript = { 'prettierd' },
                typescript = { 'prettierd' },
                javascriptreact = { 'prettierd' },
                typescriptreact = { 'prettierd' },
                css = { 'prettierd' },
                html = { 'prettierd' },
                htmlangular = { 'prettierd' },

                json = { 'jq' },

                -- cs = { 'csharpier' },

                c = { 'clang-format' },
                cpp = { 'clang-format' },
                arduino = { 'clang-format' },
                java = { 'clang-format' },

                rust = { 'rustfmt' },

                sh = { 'shfmt' },
                zsh = { 'shfmt' },
            },

            format_on_save = {
                timeout_ms = 3000,
                lsp_format = 'fallback', -- not recommended to change
            },
        }
    end,
}
