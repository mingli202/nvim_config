return {
    'sainnhe/gruvbox-material',
    lazy = false,
    priority = 1000,
    config = function()
        vim.g.gruvbox_material_enable_italic = 1
        vim.g.gruvbox_material_enable_bold = 0
        vim.g.gruvbox_material_better_performance = 1
        vim.g.gruvbox_material_transparent_background = not vim.g.neovide
        vim.g.gruvbox_material_dim_inactive_windows = 0
        vim.g.gruvbox_material_inlay_hints_background = 'dimmed'
        -- vim.g.gruvbox_material_diagnostic_virtual_text = 'colored'
        vim.g.gruvbox_material_diagnostic_line_highlight = 1
        vim.g.gruvbox_material_diagnostic_text_highlight = 1

        vim.cmd.colorscheme 'gruvbox-material'
    end,
}
