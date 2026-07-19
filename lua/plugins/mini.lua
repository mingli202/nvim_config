return { -- Collection of various small independent plugins/modules
    'echasnovski/mini.nvim',
    dependencies = { 'rafamadriz/friendly-snippets' },
    config = function()
        require('mini.icons').setup()

        local gen_loader = require('mini.snippets').gen_loader
        require('mini.snippets').setup {
            snippets = {
                gen_loader.from_lang(),
            },
        }
        require('mini.ai').setup { n_lines = 500 }
        require('mini.surround').setup()
        -- require('mini.pairs').setup()
        require('mini.files').setup {
            use_as_default_explorer = true,
            windows = {
                preview = true,
            },
            mappings = {
                go_in = '',
                go_in_plus = '<CR>',
                go_out = '-',
                go_out_plus = '',
            },
        }
        require('mini.statusline').setup {
            content = {
                active = function()
                    local mode, mode_hl = MiniStatusline.section_mode { trunc_width = 120 }
                    local filename = MiniStatusline.section_filename { trunc_width = 140 }
                    local diff = MiniStatusline.section_diff { trunc_width = 75 }
                    local git = MiniStatusline.section_git { trunc_width = 40 }
                    local diagnostics = MiniStatusline.section_diagnostics { trunc_width = 75 }

                    return MiniStatusline.combine_groups {
                        { hl = mode_hl, strings = { mode } },
                        { hl = 'MiniStatuslineFilename', strings = { filename } },
                        '%=',
                        { hl = 'MiniStatuslineFilename', strings = { diagnostics } },
                        { hl = 'MiniStatuslineDevinfo', strings = { diff, git } },
                        { hl = mode_hl, strings = { '%l|%L' } },
                    }
                end,
            },
        }

        local map = require('util').map

        map('n', '<leader>o', function()
            MiniFiles.open(vim.api.nvim_buf_get_name(0), false)
        end)
    end,
}
