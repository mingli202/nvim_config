return {
    'Wansmer/treesj',
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    opts = { use_default_keymaps = false },
    keys = {
        { 'gs', ':TSJToggle<CR>', desc = 'treesj toggle' },
    },
}
