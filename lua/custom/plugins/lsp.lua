-- NOTE: This is where your plugins related to LSP can be installed.
--  The configuration is done below. Search for lspconfig to find it below.
return {
    -- LSP Configuration & Plugins
    'neovim/nvim-lspconfig',
    dependencies = {
        -- Automatically install LSPs to stdpath for neovim
        'williamboman/mason.nvim',
        'williamboman/mason-lspconfig.nvim',

        -- Useful status updates for LSP
        -- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})
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

        -- Additional lua configuration, makes nvim stuff amazing!
        'folke/neodev.nvim',
    },
    config = function()
        -- mason-lspconfig requires that these setup functions are called in this order
        -- before setting up the servers.
        require('mason').setup()
        require('mason-lspconfig').setup()
        local lspconfig = require 'lspconfig'

        -- Enable the following language servers
        --  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
        --
        --  Add any additional override configuration in the following tables. They will be passed to
        --  the `settings` field of the server config. You must look up that documentation yourself.
        --
        --  If you want to override the default filetypes that your language server will attach to you can
        --  define the property 'filetypes' to the map in question.

        local servers = {
            csharp_ls = {},
            clangd = {},
            tsserver = {},
            html = { filetypes = { 'html', 'twig', 'hbs' } },
            cssls = {},
            marksman = {},
            r_language_server = {},
        }

        -- Setup neovim lua configuration
        require('neodev').setup()

        local capabilities = require('custom.util').capabilities

        -- Ensure the servers above are installed
        local mason_lspconfig = require 'mason-lspconfig'

        mason_lspconfig.setup {
            ensure_installed = vim.tbl_keys(servers),
        }

        mason_lspconfig.setup_handlers {
            function(server_name)
                lspconfig[server_name].setup {
                    root_dir = function()
                        return vim.fn.getcwd()
                    end,
                    capabilities = capabilities,
                    filetypes = (servers[server_name] or {}).filetypes,
                }
            end,
            ['lua_ls'] = function()
                lspconfig.lua_ls.setup {
                    capabilities = capabilities,
                    settings = {
                        Lua = {
                            workspace = {
                                checkThirdParty = false,
                                library = {
                                    vim.env.VIMRUNTIME,
                                    -- "${3rd}/luv/library"
                                    -- "${3rd}/busted/library",
                                },
                                -- or pull in all of 'runtimepath'. NOTE: this is a lot slower
                                -- library = vim.api.nvim_get_runtime_file("", true)
                            },
                            telemetry = { enable = false },
                            -- NOTE: toggle below to ignore Lua_LS's noisy `missing-fields` warnings
                            diagnostics = { disable = { 'missing-fields' }, globals = { 'vim' } },
                            runtime = {
                                -- Tell the language server which version of Lua you're using
                                -- (most likely LuaJIT in the case of Neovim)
                                version = 'LuaJIT',
                            },
                        },
                    },
                    root_dir = function()
                        return vim.fn.getcwd()
                    end,
                }
            end,
            ['arduino_language_server'] = function()
                lspconfig.arduino_language_server.setup {
                    cmd = {
                        'arduino-language-server',
                        '-clangd',
                        '/opt/homebrew/opt/llvm/bin/clangd',
                        '-cli',
                        '/opt/homebrew/opt/arduino-cli/bin/arduino-cli',
                        '-cli-config',
                        '/Users/vincentliu/Library/Arduino15/arduino-cli.yaml',
                        '-fqbn',
                        'arduino:avr:uno',
                    },
                }
            end,
            ['tailwindcss'] = function()
                lspconfig.tailwindcss.setup {
                    capabilities = capabilities,
                    filetypes = { 'javacript', 'javascriptreact', 'typescript', 'typescriptreact' },
                    root_dir = function(filename)
                        local root_files = {
                            'tailwind.config.js',
                            'tailwind.config.cjs',
                            'tailwind.config.mjs',
                            'tailwind.config.ts',
                            'postcss.config.js',
                            'postcss.config.cjs',
                            'postcss.config.mjs',
                            'postcss.config.ts',
                        }

                        local root = lspconfig.util.root_pattern(unpack(root_files))(filename)

                        return root == vim.fn.getcwd() and root or nil
                    end,
                }
            end,
            ['pyright'] = function()
                lspconfig.pyright.setup {
                    capabilities = capabilities,
                    root_dir = function()
                        return vim.fn.getcwd()
                    end,
                    settings = {
                        python = {
                            analysis = {
                                autoSearchPaths = true,
                                useLibraryCodeForTypes = true,
                                diagnosticMode = 'openFilesOnly',
                            },
                            pythonPath = '/opt/homebrew/bin/python3',
                        },
                    },
                }
            end,
        }
    end,
}
