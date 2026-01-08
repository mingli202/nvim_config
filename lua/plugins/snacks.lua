return {
    'folke/snacks.nvim',
    priority = 1000,
    lazy = false,
    ---@type snacks.Confg
    opts = {
        -- your configuration comes here
        -- or leave it empty to use the default settings
        -- refer to the configuration section below
        dim = { enabled = false },
        explorer = { enabled = true, replace_netrw = false },
        bufdelete = { enabled = true },
        dashboard = {
            enabled = true,
            sections = {
                { section = 'header' },
                { section = 'keys', padding = 1, indent = 2, title = 'Keymaps' },
                { icon = ' ', title = 'Recent Files', section = 'recent_files', indent = 2, padding = 1 },
                { icon = ' ', title = 'Projects', section = 'projects', indent = 2, padding = 1 },
                {

                    icon = ' ',
                    title = 'Git Status',
                    section = 'terminal',
                    enabled = function()
                        return Snacks.git.get_root() ~= nil
                    end,
                    cmd = 'git status --short --branch --renames',
                    height = 5,
                    padding = 1,
                    ttl = 5 * 60,
                    indent = 3,
                },
                { section = 'startup' },
            },
        },
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
            sources = {
                explorer = {
                    auto_close = true,
                    layout = {
                        fullscreen = true,
                        preview = false,
                        -- layout = { position = 'float' },
                    },
                },
            },
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
            '<leader>fr',
            function()
                Snacks.picker.recent()
            end,
            desc = 'Recent',
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
        {
            '<leader>gb',
            function()
                Snacks.picker.git_branches()
            end,
            desc = 'Git Branches',
        },
        {
            '<leader>gl',
            function()
                Snacks.picker.git_log()
            end,
            desc = 'Git Log',
        },
        {
            '<leader>gL',
            function()
                Snacks.picker.git_log_line()
            end,
            desc = 'Git Log Line',
        },
        {
            '<leader>gs',
            function()
                Snacks.picker.git_status()
            end,
            desc = 'Git Status',
        },
        {
            '<leader>gS',
            function()
                Snacks.picker.git_stash()
            end,
            desc = 'Git Stash',
        },
        {
            '<leader>gd',
            function()
                Snacks.picker.git_diff()
            end,
            desc = 'Git Diff (Hunks)',
        },
        {
            '<leader>gf',
            function()
                Snacks.picker.git_log_file()
            end,
            desc = 'Git Log File',
        },
        {
            '<leader>e',
            function()
                Snacks.explorer.open()
            end,
            desc = '[O]pen',
        },
    },
    init = function()
        vim.api.nvim_create_autocmd('User', {
            pattern = 'VeryLazy',
            callback = function()
                -- Setup some globals for debugging (lazy-loaded)
                _G.dd = function(...)
                    Snacks.debug.inspect(...)
                end
                _G.bt = function()
                    Snacks.debug.backtrace()
                end
                vim.print = _G.dd -- Override print to use snacks for `:=` command
            end,
        })
    end,
}
