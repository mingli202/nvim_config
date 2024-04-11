return {
    {
        'folke/tokyonight.nvim',
        lazy = false,
        priority = 1000,
        opts = {
            style = 'night',
            transparent = false,
        },
    },
    {
        'catppuccin/nvim',
        priority = 1000,
        name = 'catppuccin',
        lazy = false,
        opts = {
            term_colors = true,
            transparent_background = false,
            integrations = {
                neotree = true,
                which_key = true,
                ufo = true,
                mason = true,
                harpoon = true,
            },
        },
    },
    {
        'navarasu/onedark.nvim',
        priority = 1000,
        lazy = false,
        opts = {
            -- Set a style preset. 'dark' is default.
            style = 'darker', -- dark, darker, cool, deep, warm, warmer, light
            transparent = false,
            lualine = {
                transparent = false, -- lualine center bar transparency
            },
        },
    },
}
