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
            },

            format = {
                timeout_ms = 3000,
                async = false, -- not recommended to change
                quiet = false, -- not recommended to change
                lsp_fallback = true, -- not recommended to change
            },
        }

        vim.api.nvim_create_autocmd('BufWritePre', {
            pattern = '*',
            callback = function(args)
                require('conform').format { bufnr = args.buf }
            end,
        })
    end,
}
