vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

vim.g.snacks_animate = false
vim.g.have_nerd_font = false

vim.o.number = true
vim.o.relativenumber = true
vim.o.mouse = 'a'

vim.o.showmode = false

vim.schedule(function()
    vim.o.clipboard = 'unnamedplus'
end)

vim.o.breakindent = true

vim.o.undofile = true

vim.o.ignorecase = true
vim.o.smartcase = true

vim.o.signcolumn = 'yes'

vim.o.updatetime = 250

vim.o.timeoutlen = 300

vim.o.inccommand = 'split'

vim.o.cursorline = true

vim.o.scrolloff = 5

require 'mappings'

local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
    local out = vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
    if vim.v.shell_error ~= 0 then
        error('Error cloning lazy.nvim:\n' .. out)
    end
end

---@type vim.Option
local rtp = vim.opt.rtp
rtp:prepend(lazypath)

require('lazy').setup {
    -- NOTE: Plugins can be added with a link (or for a github repo: 'owner/repo' link).
    'NMAC427/guess-indent.nvim', -- Detect tabstop and shiftwidth automatically
    'tpope/vim-fugitive',
    'tpope/vim-rhubarb',

    { -- Adds git related signs to the gutter, as well as utilities for managing changes
        'lewis6991/gitsigns.nvim',
        opts = {
            signs = {
                add = { text = '+' },
                change = { text = '~' },
                delete = { text = '_' },
                topdelete = { text = '‾' },
                changedelete = { text = '~' },
            },
        },
    },

    { -- Useful plugin to show you pending keybinds.
        'folke/which-key.nvim',
        event = 'VimEnter', -- Sets the loading event to 'VimEnter'
        opts = {
            -- delay between pressing a key and opening which-key (milliseconds)
            -- this setting is independent of vim.o.timeoutlen
            delay = 0,
            icons = {
                -- set icon mappings to true if you have a Nerd Font
                mappings = vim.g.have_nerd_font,
                -- If you are using a Nerd Font: set icons.keys to an empty table which will use the
                -- default which-key.nvim defined Nerd Font icons, otherwise define a string table
                keys = vim.g.have_nerd_font and {} or {
                    Up = '<Up> ',
                    Down = '<Down> ',
                    Left = '<Left> ',
                    Right = '<Right> ',
                    C = '<C-…> ',
                    M = '<M-…> ',
                    D = '<D-…> ',
                    S = '<S-…> ',
                    CR = '<CR> ',
                    Esc = '<Esc> ',
                    ScrollWheelDown = '<ScrollWheelDown> ',
                    ScrollWheelUp = '<ScrollWheelUp> ',
                    NL = '<NL> ',
                    BS = '<BS> ',
                    Space = '<Space> ',
                    Tab = '<Tab> ',
                    F1 = '<F1>',
                    F2 = '<F2>',
                    F3 = '<F3>',
                    F4 = '<F4>',
                    F5 = '<F5>',
                    F6 = '<F6>',
                    F7 = '<F7>',
                    F8 = '<F8>',
                    F9 = '<F9>',
                    F10 = '<F10>',
                    F11 = '<F11>',
                    F12 = '<F12>',
                },
            },

            -- Document existing key chains
            spec = {
                { '<leader>s', group = '[S]earch' },
                { '<leader>t', group = '[T]oggle' },
                { '<leader>h', group = 'Git [H]unk', mode = { 'n', 'v' } },
            },
        },
    },

    {
        'folke/snacks.nvim',
        priority = 1000,
        lazy = false,
        ---@type snacks.Config
        opts = {
            -- your configuration comes here
            -- or leave it empty to use the default settings
            -- refer to the configuration section below
            bigfile = { enabled = true },
            dim = { enabled = false },
            explorer = { enabled = true },
            bufdelete = { enabled = true },
            dashboard = {
                enabled = true,
                sections = {
                    { section = 'header' },
                    { section = 'keys', padding = 1, indent = 2, title = 'Keymaps' },
                    { icon = ' ', title = 'Recent Files', section = 'recent_files', indent = 2, padding = 1 },
                    { icon = ' ', title = 'Projects', section = 'projects', indent = 2, padding = 1 },
                    {

                        icon = ' ',
                        title = 'Git Status',
                        section = 'terminal',
                        enabled = function()
                            return Snacks.git.get_root() ~= nil
                        end,
                        cmd = 'git status --short --branch --renames',
                        height = 5,
                        padding = 1,
                        ttl = 5 * 60,
                        indent = 3,
                    },
                    { section = 'startup' },
                },
            },
            debug = { enabled = true },
            git = { enabled = true },
            gitbrowse = { enabled = true },
            indent = { enabled = true },
            input = { enabled = true },
            layout = { enabled = true },
            lazygit = { enabled = true },
            notifier = { enabled = true },
            notify = { enabled = true },
            picker = {
                enabled = true,
                sources = {
                    explorer = {
                        auto_close = true,
                        layout = {
                            fullscreen = true,
                            preview = false,
                            -- layout = { position = 'float' },
                        },
                    },
                },
            },
            profiler = { enabled = true },
            quickfile = { enabled = true },
            rename = { enabled = true },
            scope = { enabled = true },
            statuscolumn = { enabled = true },
            util = { enabled = true },
            win = { enabled = true },
            words = { enabled = true },
            zen = {
                enabled = true,
                toggles = {
                    dim = false,
                    git_signs = true,
                    mini_diff_signs = false,
                    -- diagnostics = false,
                    -- inlay_hints = false,
                },
            },
        },
        keys = {
            {
                '<leader>ff',
                function()
                    Snacks.picker.files()
                end,
                desc = '[F]ind [F]ile',
            },
            {
                '<leader>fb',
                function()
                    Snacks.picker.buffers()
                end,
                desc = '[F]ind [B]uffer',
            },
            {
                '<leader>fg',
                function()
                    Snacks.picker.grep()
                end,
                desc = '[F]ind [G]rep',
            },
            {
                '<leader>.',
                function()
                    Snacks.picker.lines()
                end,
                desc = '[F]ind lines',
            },
            {
                '<leader>ft',
                function()
                    Snacks.picker.colorschemes()
                end,
                desc = '[F]ind theme',
            },
            {
                '<leader>z',
                function()
                    Snacks.zen()
                end,
                desc = '[Z]en',
            },
            {
                '<leader>cb',
                function()
                    Snacks.bufdelete()
                end,
                desc = '[C]lose [B]uffer',
            },
            {
                '<leader>fm',
                function()
                    Snacks.picker.marks()
                end,
                desc = '[F]ind [M]ark',
            },
            {
                '<leader>gb',
                function()
                    Snacks.picker.git_branches()
                end,
                desc = 'Git Branches',
            },
            {
                '<leader>gl',
                function()
                    Snacks.picker.git_log()
                end,
                desc = 'Git Log',
            },
            {
                '<leader>gL',
                function()
                    Snacks.picker.git_log_line()
                end,
                desc = 'Git Log Line',
            },
            {
                '<leader>gs',
                function()
                    Snacks.picker.git_status()
                end,
                desc = 'Git Status',
            },
            {
                '<leader>gS',
                function()
                    Snacks.picker.git_stash()
                end,
                desc = 'Git Stash',
            },
            {
                '<leader>gd',
                function()
                    Snacks.picker.git_diff()
                end,
                desc = 'Git Diff (Hunks)',
            },
            {
                '<leader>gf',
                function()
                    Snacks.picker.git_log_file()
                end,
                desc = 'Git Log File',
            },
            {
                '<leader>o',
                function()
                    Snacks.explorer.open()
                end,
                desc = '[O]pen',
            },
        },
        init = function()
            vim.api.nvim_create_autocmd('User', {
                pattern = 'VeryLazy',
                callback = function()
                    -- Setup some globals for debugging (lazy-loaded)
                    _G.dd = function(...)
                        Snacks.debug.inspect(...)
                    end
                    _G.bt = function()
                        Snacks.debug.backtrace()
                    end
                    vim.print = _G.dd -- Override print to use snacks for `:=` command
                end,
            })
        end,
    },
    -- LSP Plugins
    {
        -- `lazydev` configures Lua LSP for your Neovim config, runtime and plugins
        -- used for completion, annotations and signatures of Neovim apis
        'folke/lazydev.nvim',
        ft = 'lua',
        opts = {
            library = {
                -- Load luvit types when the `vim.uv` word is found
                { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
            },
        },
    },
    {
        -- Main LSP Configuration
        'neovim/nvim-lspconfig',
        dependencies = {
            -- Automatically install LSPs and related tools to stdpath for Neovim
            -- Mason must be loaded before its dependents so we need to set it up here.
            -- NOTE: `opts = {}` is the same as calling `require('mason').setup({})`
            { 'mason-org/mason.nvim', opts = {} },
            'mason-org/mason-lspconfig.nvim',
            'WhoIsSethDaniel/mason-tool-installer.nvim',

            -- Useful status updates for LSP.
            {
                'j-hui/fidget.nvim',
                opts = {
                    notification = {
                        window = {
                            winblend = 0,
                        },
                    },
                },
            },
            -- Allows extra capabilities provided by blink.cmp
            'saghen/blink.cmp',
        },
        config = function()
            vim.api.nvim_create_autocmd('LspAttach', {
                group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
                callback = function(event)
                    local map = function(keys, func, desc, mode)
                        mode = mode or 'n'
                        vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
                    end

                    map('K', function()
                        vim.lsp.buf.hover { border = 'solid' }
                    end, 'Lsp Hover')

                    map('grr', function()
                        Snacks.picker.lsp_references()
                    end, '[G]oto [R]eferences')
                    map('gri', function()
                        Snacks.picker.lsp_implementations()
                    end, '[G]oto [I]mplementation')
                    map('grd', function()
                        Snacks.picker.lsp_definitions()
                    end, '[G]oto [D]efinition')
                    map('grD', function()
                        Snacks.picker.lsp_declarations()
                    end, '[G]oto [D]eclaration')
                    map('gO', function()
                        Snacks.picker.lsp_symbols()
                    end, 'Open Document Symbols')
                    map('gW', function()
                        Snacks.picker.lsp_workspace_symbols()
                    end, 'Open Workspace Symbols')
                    map('grt', function()
                        Snacks.picker.lsp_type_definitions()
                    end, '[G]oto [T]ype Definition')

                    ---@param client vim.lsp.Client
                    ---@param method vim.lsp.protocol.Method
                    ---@param bufnr? integer some lsp support methods only in specific files
                    ---@return boolean
                    local function client_supports_method(client, method, bufnr)
                        if vim.fn.has 'nvim-0.11' == 1 then
                            return client:supports_method(method, bufnr)
                        else
                            return client.supports_method(method, { bufnr = bufnr })
                        end
                    end

                    -- The following code creates a keymap to toggle inlay hints in your
                    -- code, if the language server you are using supports them
                    --
                    -- This may be unwanted, since they displace some of your code
                    if client and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_inlayHint, event.buf) then
                        map('<leader>th', function()
                            vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
                        end, '[T]oggle Inlay [H]ints')
                    end
                end,
            })

            -- Diagnostic Config
            -- See :help vim.diagnostic.Opts
            vim.diagnostic.config {
                severity_sort = true,
                float = { border = 'solid' },
                jump = {
                    float = true,
                },
                signs = vim.g.have_nerd_font and {
                    text = {
                        [vim.diagnostic.severity.ERROR] = '󰅚 ',
                        [vim.diagnostic.severity.WARN] = '󰀪 ',
                        [vim.diagnostic.severity.INFO] = '󰋽 ',
                        [vim.diagnostic.severity.HINT] = '󰌶 ',
                    },
                } or {},
                virtual_text = true,
            }

            local capabilities = require('blink.cmp').get_lsp_capabilities()

            local servers = {
                -- clangd = {},
                -- gopls = {},
                pyright = {},
                rust_analyzer = {
                    settings = {
                        ['rust-analyzer'] = {
                            diagnostics = {
                                styleLints = {
                                    enable = true,
                                },
                            },
                            check = {
                                command = 'clippy',
                            },
                            imports = {
                                granularity = {
                                    group = 'module',
                                },
                                prefix = 'self',
                            },
                            cargo = {
                                buildScripts = {
                                    enable = true,
                                },
                            },
                            procMacro = {
                                enable = true,
                            },
                        },
                    },
                },
                vtsls = {},
                html = {},
                cssls = {},
                omnisharp = {},
                tailwindcss = {},
                ruff = {},
                bashls = {},
                dockerls = {},
                yamlls = {},
                taplo = {},

                lua_ls = {
                    settings = {
                        Lua = {
                            completion = {
                                callSnippet = 'Replace',
                            },
                            -- You can toggle below to ignore Lua_LS's noisy `missing-fields` warnings
                            -- diagnostics = { disable = { 'missing-fields' } },
                        },
                    },
                },
            }

            local ensure_installed = vim.tbl_keys(servers or {})
            vim.list_extend(ensure_installed, {
                'stylua',
                -- 'csharpier',
                'jq',
                'prettierd',
                'eslint_d',
                -- 'cspell',
                'js-debug-adapter',
                'debugpy',
                'shfmt',
                'shellcheck',
                'codelldb',
                'mypy',
                'clang-format',
                -- 'java-debug-adapter',
                -- 'java-test',
            })
            require('mason-tool-installer').setup { ensure_installed = ensure_installed }

            require('mason-lspconfig').setup {
                ensure_installed = {}, -- explicitly set to an empty table (Kickstart populates installs via mason-tool-installer)
                automatic_installation = false,
                handlers = {
                    function(server_name)
                        local server = servers[server_name] or {}
                        -- This handles overriding only values explicitly passed
                        -- by the server configuration above. Useful when disabling
                        -- certain features of an LSP (for example, turning off formatting for ts_ls)
                        server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
                        require('lspconfig')[server_name].setup(server)
                    end,
                },
            }
        end,
    },

    { -- Autoformat
        'stevearc/conform.nvim',
        event = { 'BufWritePre' },
        cmd = { 'ConformInfo' },
        keys = {
            {
                '<leader>f',
                function()
                    require('conform').format { async = true, lsp_format = 'fallback' }
                end,
                mode = '',
                desc = '[F]ormat buffer',
            },
        },
        opts = {
            notify_on_error = false,
            format_on_save = function(bufnr)
                -- Disable "format_on_save lsp_fallback" for languages that don't
                -- have a well standardized coding style. You can add additional
                -- languages here or re-enable it for the disabled ones.
                local disable_filetypes = { cs = true }
                if disable_filetypes[vim.bo[bufnr].filetype] then
                    return nil
                else
                    return {
                        timeout_ms = 3000,
                        lsp_format = 'fallback',
                    }
                end
            end,
            formatters_by_ft = {
                lua = { 'stylua' },

                javascript = { 'prettierd' },
                typescript = { 'prettierd' },
                javascriptreact = { 'prettierd' },
                typescriptreact = { 'prettierd' },
                css = { 'prettierd' },
                html = { 'prettierd' },

                json = { 'jq' },

                c = { 'clang-format' },
                cpp = { 'clang-format' },
                arduino = { 'clang-format' },
                java = { 'clang-format' },

                rust = { 'rustfmt' },

                sh = { 'shfmt' },
                zsh = { 'shfmt' },
            },
        },
    },

    { -- Autocompletion
        'saghen/blink.cmp',
        event = 'VimEnter',
        version = '1.*',
        dependencies = {
            -- Snippet Engine
            {
                'L3MON4D3/LuaSnip',
                version = '2.*',
                build = (function()
                    -- Build Step is needed for regex support in snippets.
                    -- This step is not supported in many windows environments.
                    -- Remove the below condition to re-enable on windows.
                    if vim.fn.has 'win32' == 1 or vim.fn.executable 'make' == 0 then
                        return
                    end

                    return 'make install_jsregexp'
                end)(),
                opts = {},
            },
            'folke/lazydev.nvim',
        },
        --- @module 'blink.cmp'
        --- @type blink.cmp.Config
        opts = {
            keymap = {
                preset = 'default',
            },

            appearance = {
                nerd_font_variant = 'mono',
            },

            completion = {
                -- By default, you may press `<c-space>` to show the documentation.
                -- Optionally, set `auto_show = true` to show the documentation after a delay.
                documentation = { auto_show = true, auto_show_delay_ms = 0 },
                list = { selection = { preselect = false, auto_insert = true } },
            },

            sources = {
                default = { 'lsp', 'path', 'snippets', 'lazydev' },
                providers = {
                    lazydev = { module = 'lazydev.integrations.blink', score_offset = 100 },
                    path = { opts = { show_hidden_files_by_default = true } },
                },
            },

            snippets = { preset = 'luasnip' },

            -- Blink.cmp includes an optional, recommended rust fuzzy matcher,
            -- which automatically downloads a prebuilt binary when enabled.
            --
            -- By default, we use the Lua implementation instead, but you may enable
            -- the rust implementation via `'prefer_rust_with_warning'`
            --
            -- See :h blink-cmp-config-fuzzy for more information
            fuzzy = { implementation = 'prefer_rust_with_warning' },

            -- Shows a signature help window while you type arguments for a function
            signature = { enabled = true },

            cmdline = {
                keymap = { preset = 'inherit' },
                completion = {
                    menu = { auto_show = true },
                    list = { selection = { preselect = false, auto_insert = true } },
                },
            },
        },
    },

    {
        'sainnhe/gruvbox-material',
        lazy = false,
        priority = 1000,
        config = function()
            vim.g.gruvbox_material_enable_italic = true
            vim.g.gruvbox_material_enable_bold = 1
            vim.g.gruvbox_material_better_performance = 1
            vim.g.gruvbox_material_transparent_background = not vim.g.neovide
            vim.g.gruvbox_material_dim_inactive_windows = 1
            vim.g.gruvbox_material_inlay_hints_background = 'dimmed'

            vim.cmd.colorscheme 'gruvbox-material'
        end,
    },

    -- Highlight todo, notes, etc in comments
    { 'folke/todo-comments.nvim', event = 'VimEnter', dependencies = { 'nvim-lua/plenary.nvim' }, opts = { signs = false } },

    { -- Collection of various small independent plugins/modules
        'echasnovski/mini.nvim',
        config = function()
            require('mini.ai').setup { n_lines = 500 }
            require('mini.surround').setup()
            -- require('mini.pairs').setup()
        end,
    },

    { -- Highlight, edit, and navigate code
        'nvim-treesitter/nvim-treesitter',
        build = ':TSUpdate',
        dependencies = {
            'nvim-treesitter/nvim-treesitter-textobjects',
            { 'nvim-treesitter/nvim-treesitter-context', opts = { max_lines = 5 } },
        },
        main = 'nvim-treesitter.configs', -- Sets main module to use for opts
        -- [[ Configure Treesitter ]] See `:help nvim-treesitter`
        opts = {
            ensure_installed = { 'bash', 'c', 'diff', 'html', 'lua', 'luadoc', 'markdown', 'markdown_inline', 'query', 'vim', 'vimdoc' },
            -- Autoinstall languages that are not installed
            auto_install = true,
            highlight = {
                enable = true,
                -- Some languages depend on vim's regex highlighting system (such as Ruby) for indent rules.
                --  If you are experiencing weird indenting issues, add the language to
                --  the list of additional_vim_regex_highlighting and disabled languages for indent.
                additional_vim_regex_highlighting = { 'ruby' },
            },
            indent = { enable = true, disable = { 'ruby' } },
        },
    },

    {
        -- Set lualine as statusline
        'nvim-lualine/lualine.nvim',
        -- See `:help lualine.txt`
        config = function()
            require('lualine').setup {
                options = { -- custom options
                    theme = 'auto',
                    icons_enabled = false,
                    component_separators = '|',
                    section_separators = { left = '', right = '' },
                },
                sections = {
                    lualine_a = { 'mode' },
                    lualine_b = {},
                    lualine_c = { {
                        'filename',
                        path = 1,
                    } },
                    lualine_x = {
                        'diagnostics',
                    },
                    lualine_y = {
                        'diff',
                        'branch',
                    },
                    lualine_z = {
                        'progress',
                    },
                },
            }
        end,
    },

    {
        'Wansmer/treesj',
        dependencies = { 'nvim-treesitter/nvim-treesitter' },
        opts = { use_default_keymaps = false },
        keys = {
            { 'gs', ':TSJToggle<CR>', desc = 'treesj toggle' },
        },
    },

    {
        'mfussenegger/nvim-lint',
        event = 'VeryLazy',
        config = function()
            local lint = require 'lint'

            lint.linters.mypy.args = {
                '--show-column-numbers',
                '--show-error-end',
                '--hide-error-codes',
                '--hide-error-context',
                '--no-color-output',
                '--no-error-summary',
                '--no-pretty',
                '--ignore-missing-imports',
                '--check-untyped-defs',
            }

            lint.linters_by_ft = {
                javascript = { 'eslint_d' },
                typescript = { 'eslint_d' },
                javascriptreact = { 'eslint_d' },
                typescriptreact = { 'eslint_d' },

                sh = { 'shellcheck' },

                python = { 'mypy' },
            }

            vim.api.nvim_create_autocmd({ 'BufWritePost', 'BufEnter' }, {
                -- group = vim.api.nvim_create_augroup('Linter', { clear = true }),
                callback = function()
                    -- try_lint without arguments runs the linters defined in `linters_by_ft`
                    -- for the current filetype
                    lint.try_lint()
                end,
            })
        end,
    },

    {
        'christoomey/vim-tmux-navigator',
        cmd = {
            'TmuxNavigateLeft',
            'TmuxNavigateDown',
            'TmuxNavigateUp',
            'TmuxNavigateRight',
            'TmuxNavigatePrevious',
        },
        keys = {
            { '<c-h>', '<cmd><C-U>TmuxNavigateLeft<cr>' },
            { '<c-j>', '<cmd><C-U>TmuxNavigateDown<cr>' },
            { '<c-k>', '<cmd><C-U>TmuxNavigateUp<cr>' },
            { '<c-l>', '<cmd><C-U>TmuxNavigateRight<cr>' },
            { '<c-\\>', '<cmd><C-U>TmuxNavigatePrevious<cr>' },
        },
        lazy = false,
    },
}

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
