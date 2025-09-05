return {
    'ThePrimeagen/harpoon',
    branch = 'harpoon2',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
        local harpoon = require 'harpoon'

        harpoon:setup()

        local map = require('util').map

        map('n', '<leader>hl', function()
            harpoon.ui:toggle_quick_menu(harpoon:list())
        end)

        map('n', '<leader>ha', function()
            harpoon:list():add()
        end)

        map('n', '<leader>h1', function()
            harpoon:list():select(1)
        end)
        map('n', '<leader>h2', function()
            harpoon:list():select(2)
        end)
        map('n', '<leader>h3', function()
            harpoon:list():select(3)
        end)
        map('n', '<leader>h4', function()
            harpoon:list():select(4)
        end)
        map('n', '<leader>h5', function()
            harpoon:list():select(5)
        end)
        map('n', '<leader>h6', function()
            harpoon:list():select(6)
        end)
        map('n', '<leader>h7', function()
            harpoon:list():select(7)
        end)
        map('n', '<leader>h8', function()
            harpoon:list():select(8)
        end)
        map('n', '<leader>h9', function()
            harpoon:list():select(9)
        end)

        map('n', '<leader>hd', function()
            harpoon:list():remove()
        end)
    end,
}
