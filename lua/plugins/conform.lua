return { -- Autoformat
    'stevearc/conform.nvim',
    event = { 'BufWritePre' },
    cmd = { 'ConformInfo' },
    keys = {
        {
            '<leader>f',
            function()
                require('conform').format { async = true, lsp_format = 'fallback' }
            end,
            mode = '',
            desc = '[F]ormat buffer',
        },
    },
    opts = {
        notify_on_error = false,
        format_on_save = function(bufnr)
            -- Disable "format_on_save lsp_fallback" for languages that don't
            -- have a well standardized coding style. You can add additional
            -- languages here or re-enable it for the disabled ones.
            local disable_filetypes = {}
            if disable_filetypes[vim.bo[bufnr].filetype] then
                return nil
            else
                return {
                    timeout_ms = 3000,
                    lsp_format = 'fallback',
                }
            end
        end,
        formatters_by_ft = {
            lua = { 'stylua' },

            javascript = { 'oxfmt', 'prettierd' },
            typescript = { 'oxfmt', 'prettierd' },
            javascriptreact = { 'oxfmt', 'prettierd' },
            typescriptreact = { 'oxfmt', 'prettierd' },
            css = { 'oxfmt', 'prettierd' },
            html = { 'oxfmt', 'prettierd' },
            xml = { 'oxfmt', 'prettierd' },

            json = { 'jq' },

            c = { 'clang-format' },
            cpp = { 'clang-format' },
            arduino = { 'clang-format' },
            java = { 'clang-format' },

            rust = { 'rustfmt' },

            sh = { 'shfmt' },
            zsh = { 'shfmt' },
        },
    },
}
