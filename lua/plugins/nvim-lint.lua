return {
    'mfussenegger/nvim-lint',
    event = 'VeryLazy',
    config = function()
        local lint = require 'lint'

        lint.linters.mypy.args = {
            '--show-column-numbers',
            '--show-error-end',
            '--hide-error-codes',
            '--hide-error-context',
            '--no-color-output',
            '--no-error-summary',
            '--no-pretty',
            '--ignore-missing-imports',
            '--check-untyped-defs',
        }

        lint.linters_by_ft = {
            javascript = { 'oxlint' },
            typescript = { 'oxlint' },
            javascriptreact = { 'oxlint' },
            typescriptreact = { 'oxlint' },

            sh = { 'shellcheck' },

            python = { 'mypy' },
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
