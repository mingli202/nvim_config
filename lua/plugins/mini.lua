return {
    'echasnovski/mini.nvim',
    version = false,
    config = function()
        require('mini.ai').setup()
        require('mini.surround').setup { n_lines = 500 }
        require('mini.pairs').setup()
    end,
}
