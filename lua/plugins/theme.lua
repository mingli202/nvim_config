return {
    -- {
    --     'folke/tokyonight.nvim',
    --     lazy = false,
    --     priority = 1000,
    --     opts = {
    --         style = 'night',
    --         transparent = not vim.g.neovide,
    --         cache = false,
    --     },
    -- },

    -- {
    --     'catppuccin/nvim',
    --     priority = 1000,
    --     name = 'catppuccin',
    --     lazy = false,
    --     opts = {
    --         term_colors = true,
    --         transparent_background = true,
    --         integrations = {
    --             neotree = true,
    --             which_key = true,
    --             ufo = true,
    --             mason = true,
    --             harpoon = true,
    --             dashboard = true,
    --             fidget = true,
    --             indent_blankline = true,
    --             mini = {
    --                 enabled = true,
    --                 indentscope_color = '', -- catppuccin color (eg. `lavender`) Default: text
    --             },
    --             cmp = true,
    --             dap = true,
    --             dap_ui = true,
    --             native_lsp = {
    --                 enabled = true,
    --                 virtual_text = {
    --                     errors = { 'italic' },
    --                     hints = { 'italic' },
    --                     warnings = { 'italic' },
    --                     information = { 'italic' },
    --                     ok = { 'italic' },
    --                 },
    --                 underlines = {
    --                     errors = { 'underline' },
    --                     hints = { 'underline' },
    --                     warnings = { 'underline' },
    --                     information = { 'underline' },
    --                     ok = { 'underline' },
    --                 },
    --                 inlay_hints = {
    --                     background = true,
    --                 },
    --             },
    --             treesitter_context = true,
    --             treesitter = true,
    --             lsp_trouble = true,
    --             telescope = {
    --                 enabled = true,
    --                 -- style = "nvchad"
    --             },
    --         },
    --     },
    -- },

    -- {
    --     'navarasu/onedark.nvim',
    --     priority = 1000,
    --     lazy = false,
    --     opts = {
    --         -- Set a style preset. 'dark' is default.
    --         style = 'darker', -- dark, darker, cool, deep, warm, warmer, light
    --         transparent = true,
    --         lualine = {
    --             transparent = true, -- lualine center bar transparency
    --         },
    --     },
    -- },

    {
        'sainnhe/gruvbox-material',
        lazy = false,
        priority = 1000,
        config = function()
            vim.g.gruvbox_material_enable_italic = true
            -- vim.g.gruvbox_material_enable_bold = 1
            vim.g.gruvbox_material_better_performance = 1
            vim.g.gruvbox_material_transparent_background = false
            vim.g.gruvbox_material_dim_inactive_windows = 1
            vim.g.gruvbox_material_inlay_hints_background = 'dimmed'
        end,
    },
}
