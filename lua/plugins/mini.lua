return {
    'echasnovski/mini.nvim',
    version = false,
    config = function()
        require('mini.ai').setup()
        require('mini.surround').setup { n_lines = 500 }

        if not vim.g.neovide then
            require('mini.icons').setup()

            local animate = require 'mini.animate'
            local timing = animate.gen_timing.exponential { easing = 'out', duration = 150, unit = 'total' }
            animate.setup {
                cursor = {
                    timing = timing,
                },
                scroll = {
                    timing = timing,
                    subscroll = animate.gen_subscroll.equal { max_output_steps = 480 },
                },
                resize = {
                    enable = false,
                },
                open = {
                    enable = false,
                },
                close = {
                    enable = false,
                },
            }
        end
    end,
}
