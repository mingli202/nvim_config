return {

    -- Fuzzy Finder (files, lsp, etc)

    'nvim-telescope/telescope.nvim',
    branch = '0.1.x',
    dependencies = {
        'nvim-lua/plenary.nvim',
        -- Fuzzy Finder Algorithm which requires local dependencies to be built.
        -- Only load if `make` is available. Make sure you have the system
        -- requirements installed.
        {
            'nvim-telescope/telescope-fzf-native.nvim',
            -- NOTE: If you are having trouble with this installation,
            --       refer to the README for telescope-fzf-native for more instructions.
            build = 'make',
        },
    },

    config = function()
        -- [[ Configure Telescope ]]
        -- See `:help telescope` and `:help telescope.setup()`
        require('telescope').setup {
            defaults = {
                mappings = {
                    i = {
                        ['<C-u>'] = false,
                        ['<C-d>'] = false,
                    },
                    n = {
                        ['q'] = require('telescope.actions').close,
                    },
                },
                borderchars = { ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ' },
            },
        }

        -- Enable telescope fzf native, if installed
        pcall(require('telescope').load_extension, 'fzf')
        local telescope = require 'telescope.builtin'

        -- See `:help telescope.builtin`
        vim.keymap.set('n', '<leader>?', telescope.oldfiles, { desc = '[?] Find recently opened files' })
        vim.keymap.set('n', '<leader>fb', telescope.buffers, { desc = '[F]ind existing [B]uffers' })
        vim.keymap.set('n', '<leader>.', function()
            -- You can pass additional configuration to telescope to change theme, layout, etc.
            require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
                previewer = false,
            })
        end, { desc = '[.] Fuzzily search in current buffer' })

        local function telescope_live_grep_open_files()
            telescope.live_grep {
                grep_open_files = true,
                prompt_title = 'Live Grep in Open Files',
            }
        end

        vim.keymap.set('n', '<leader>f/', telescope_live_grep_open_files, { desc = '[F]ind [/] in Open Files' })
        vim.keymap.set('n', '<leader>fs', telescope.builtin, { desc = '[F]ind [S]elect Telescope' })
        vim.keymap.set('n', '<leader>gf', telescope.git_files, { desc = 'Search [G]it [F]iles' })
        vim.keymap.set('n', '<leader>ff', telescope.find_files, { desc = '[F]ind [F]iles' })
        vim.keymap.set('n', '<leader>fF', function()
            telescope.find_files { hidden = true }
        end, { desc = '[F]ind [F]iles (hidden)' })
        vim.keymap.set('n', '<leader>fh', telescope.help_tags, { desc = '[F]ind [H]elp' })
        vim.keymap.set('n', '<leader>fw', telescope.grep_string, { desc = '[F]ind current [W]ord' })
        vim.keymap.set('n', '<leader>fg', telescope.live_grep, { desc = '[F]ind by [G]rep' })
        vim.keymap.set('n', '<leader>fG', ':LiveGrepGitRoot<cr>', { desc = '[F]ind by [G]rep on Git Root' })
        vim.keymap.set('n', '<leader>fd', telescope.diagnostics, { desc = '[F]ind [D]iagnostics' })
        vim.keymap.set('n', '<leader>ft', function()
            telescope.colorscheme { enable_preview = true }
        end, { desc = '[F]ind [T]hemes' })
    end,
}
