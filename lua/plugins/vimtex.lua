return {
    'lervag/vimtex',
    init = function()
        -- Use init for configuration, don't use the more common "config".
        vim.g.vimtex_view_method = 'skim'
        vim.g.vimtex_compiler_method = 'latexmk'
        vim.g.tex_flavor = 'latex'
        vim.g.vimtex_quickfix_mode = 0
        vim.cmd 'set conceallevel=0'
        vim.g.tex_conceal = 'abdmg'
        vim.g.vimtex_mappings_enabled = 0
    end,
}
