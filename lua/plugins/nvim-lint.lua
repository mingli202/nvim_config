return {
    'mfussenegger/nvim-lint',
    config = function()
        local lint = require 'lint'

        lint.linters_by_ft = {
            -- markdown = { 'cspell' },
            norg = { 'cspell' },

            javascript = { 'eslint_d' },
            typescript = { 'eslint_d' },
            javascriptreact = { 'eslint_d' },
            typescriptreact = { 'eslint_d' },

            sh = { 'shellcheck' },
            dockerfile = { 'hadolint' },
        }

        vim.api.nvim_create_autocmd({ 'BufWritePost', 'BufEnter' }, {
            -- group = vim.api.nvim_create_augroup('Linter', { clear = true }),
            callback = function()
                -- try_lint without arguments runs the linters defined in `linters_by_ft`
                -- for the current filetype
                lint.try_lint()
            end,
        })
    end,
}
