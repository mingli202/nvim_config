return {
    'nvim-neorg/neorg',
    lazy = true, -- enable lazy load
    ft = 'norg', -- lazy load on file type
    cmd = 'Neorg', -- lazy load on command
    version = '*',
    opts = {
        load = {
            ['core.defaults'] = {}, -- Loads default behaviour
            ['core.concealer'] = {}, -- Adds pretty icons to your documents
            ['core.dirman'] = { -- Manages Neorg workspaces
                config = {
                    workspaces = {
                        notes = '~/notes',
                    },
                },
            },
            ['core.completion'] = {
                config = {
                    engine = 'nvim-cmp',
                },
            },
            ['core.export'] = {
                config = {
                    render_on_enter = true,
                },
            },
            ['core.integrations.treesitter'] = {},
        },
    },
    config = function(_, opts)
        require('neorg').setup(opts)
    end,
}
