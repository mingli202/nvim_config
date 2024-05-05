return {
    'nvim-neo-tree/neo-tree.nvim',
    branch = 'v3.x',
    dependencies = {
        'nvim-lua/plenary.nvim',
        'nvim-tree/nvim-web-devicons', -- not strictly required, but recommended
        'MunifTanjim/nui.nvim',
        -- "3rd/image.nvim", -- Optional image support in preview window: See `# Preview Mode` for more information
    },
    keys = {
        { '<leader>o', ':Neotree position=current reveal=true <CR>', desc = '[O]pen explorer window', noremap = true, silent = true },
    },
    config = function()
        require('neo-tree').setup {
            window = {
                mappings = {
                    ['h'] = 'close_node',
                    ['l'] = 'open',
                },
                position = 'current',
            },
            close_if_last_window = true,
        }

        -- neotree
        local map = require('util').map
        map('n', '<leader>ce', ':Neotree close <CR>', { desc = '[C]lose [E]xplorer' })
    end,
}
