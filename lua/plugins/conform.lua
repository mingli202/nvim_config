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
                markdown = { 'prettierd' },
                html = { 'prettierd' },
                css = { 'prettierd' },
                scss = { 'prettierd' },
                less = { 'prettierd' },
                vue = { 'prettierd' },

                json = { 'jq' },

                cs = { 'csharpier' },

                c = { 'clang-format' },
                cpp = { 'clang-format' },
                arduino = { 'clang-format' },

                rust = { 'rustfmt' },
            },

            format_on_save = {
                timeout_ms = 3000,
                lsp_fallback = true, -- not recommended to change
            },
        }
    end,
}
