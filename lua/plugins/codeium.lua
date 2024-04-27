return {
    'Exafunction/codeium.vim',
    event = 'BufEnter',
    config = function()
        vim.g.codeium_disable_bindings = 1

        -- Change '<C-g>' here to any keycode you like.
        vim.keymap.set('i', '<C-y>', function()
            return vim.fn['codeium#Accept']()
        end, { expr = true, silent = true })

        vim.keymap.set('i', '‘', function()
            return vim.fn['codeium#CycleCompletions'](1)
        end, { expr = true, silent = true })

        vim.keymap.set('i', '“', function()
            return vim.fn['codeium#CycleCompletions'](-1)
        end, { expr = true, silent = true })

        vim.keymap.set('i', '<c-x>', function()
            return vim.fn['codeium#Clear']()
        end, { expr = true, silent = true })

        -- create user command for codeium chat
        vim.api.nvim_create_user_command('CodeiumChat', function()
            vim.fn['codeium#Chat']()
        end, {})
    end,
}
