return {
    'folke/snacks.nvim',
    priority = 1000,
    lazy = false,
    ---@type snacks.Config
    opts = {
        -- your configuration comes here
        -- or leave it empty to use the default settings
        -- refer to the configuration section below
        bigfile = { enabled = true },
        dim = { enabled = false },
        bufdelete = { enabled = true },
        dashboard = { enabled = true },
        debug = { enabled = true },
        git = { enabled = true },
        gitbrowse = { enabled = true },
        indent = { enabled = true },
        input = { enabled = true },
        layout = { enabled = true },
        lazygit = { enabled = true },
        notifier = { enabled = true },
        notify = { enabled = true },
        picker = {
            enabled = true,
        },
        profiler = { enabled = true },
        quickfile = { enabled = true },
        rename = { enabled = true },
        scope = { enabled = true },
        statuscolumn = { enabled = true },
        util = { enabled = true },
        win = { enabled = true },
        words = { enabled = true },
        zen = {
            enabled = true,
            toggles = {
                dim = false,
                git_signs = true,
                mini_diff_signs = false,
                -- diagnostics = false,
                -- inlay_hints = false,
            },
        },
    },
    keys = {
        {
            '<leader>ff',
            function()
                Snacks.picker.files()
            end,
            desc = '[F]ind [F]ile',
        },
        {
            '<leader>fb',
            function()
                Snacks.picker.buffers()
            end,
            desc = '[F]ind [B]uffer',
        },
        {
            '<leader>fg',
            function()
                Snacks.picker.grep()
            end,
            desc = '[F]ind [G]rep',
        },
        {
            '<leader>.',
            function()
                Snacks.picker.lines()
            end,
            desc = '[F]ind lines',
        },
        {
            '<leader>ft',
            function()
                Snacks.picker.colorschemes()
            end,
            desc = '[F]ind theme',
        },
        {
            '<leader>z',
            function()
                Snacks.zen()
            end,
            desc = '[Z]en',
        },
        {
            '<leader>cb',
            function()
                Snacks.bufdelete()
            end,
            desc = '[C]lose [B]uffer',
        },
        {
            '<leader>fm',
            function()
                Snacks.picker.marks()
            end,
            desc = '[F]ind [M]ark',
        },
    },
}
