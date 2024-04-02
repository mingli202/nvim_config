return {
    'kylechui/nvim-surround',
    version = '*', -- Use for stability; omit to use `main` branch for the latest features
    event = 'VeryLazy',
    opts = {
        keymaps = {
            insert = '<C-g>s',
            insert_line = '<C-g>S',
            normal = 's',
            normal_cur = 'ss',
            normal_line = 'S',
            normal_cur_line = 'SS',
            visual = 'S',
            visual_line = 'gS',
            delete = 'ds',
            change = 'cs',
            change_line = 'cS',
        },
    },
}
