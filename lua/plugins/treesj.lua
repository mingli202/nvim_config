return {
    'Wansmer/treesj',
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    opts = { use_default_keymaps = false },
    config = function(_, opts)
        local map = require('util').map
        local treesj = require 'treesj'
        treesj.setup(opts)

        map('n', 'gs', treesj.toggle, { desc = 'treesj toggle' })
    end,
}
