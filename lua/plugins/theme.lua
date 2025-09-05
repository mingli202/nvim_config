return {
    'sainnhe/gruvbox-material',
    lazy = false,
    priority = 1000,
    config = function()
        vim.g.gruvbox_material_enable_italic = true
        vim.g.gruvbox_material_enable_bold = 0
        vim.g.gruvbox_material_better_performance = 1
        vim.g.gruvbox_material_transparent_background = not vim.g.neovide
        vim.g.gruvbox_material_dim_inactive_windows = 1
        vim.g.gruvbox_material_inlay_hints_background = 'dimmed'

        vim.cmd.colorscheme 'gruvbox-material'
    end,
}
