return {
    'Exafunction/windsurf.vim',
    event = 'BufEnter',
    config = function()
        vim.g.codeium_disable_bindings = 1

        local map = require('util').map

        map('i', '<C-q>', function()
            return vim.fn['codeium#Accept']()
        end, { expr = true })
        map('i', "<C-'>", function()
            return vim.fn['codeium#CycleCompletions'](1)
        end, { expr = true })
        map('i', '<C-;>', function()
            return vim.fn['codeium#CycleCompletions'](-1)
        end, { expr = true })

        -- create user command for codeium chat
        vim.api.nvim_create_user_command('CodeiumChat', function()
            vim.fn['codeium#Chat']()
        end, {})
    end,
}
