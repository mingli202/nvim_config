-- NOTE: This is where your plugins related to LSP can be installed.
--  The configuration is done below. Search for lspconfig to find it below.
return {
    -- LSP Configuration & Plugins
    'neovim/nvim-lspconfig',
    dependencies = {
        -- Automatically install LSPs to stdpath for neovim
        'williamboman/mason.nvim',
        'williamboman/mason-lspconfig.nvim',
        'WhoIsSethDaniel/mason-tool-installer.nvim',

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
            html = { filetypes = { 'html', 'twig', 'hbs' } },
            cssls = {},
            -- r_language_server = {},
            -- texlab = {},
            -- omnisharp = {},
            tailwindcss = {},
            pyright = {
                settings = {
                    pyright = {
                        -- Using Ruff's import organizer
                        disableOrganizeImports = true,
                    },
                },
            },
            ruff = {},
            vtsls = {},
            bashls = {},
            dockerls = {},
            rust_analyzer = {
                settings = {
                    ['rust-analyzer'] = {
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
            lua_ls = {
                settings = {
                    Lua = {
                        runtime = {
                            -- Tell the language server which version of Lua you're using
                            -- (most likely LuaJIT in the case of Neovim)
                            version = 'LuaJIT',
                        },
                        -- Make the server aware of Neovim runtime files
                        workspace = {
                            checkThirdParty = false,
                            library = {
                                vim.env.VIMRUNTIME,
                                -- Depending on the usage, you might want to add additional paths here.
                                -- "${3rd}/luv/library"
                                -- "${3rd}/busted/library",
                            },
                            -- or pull in all of 'runtimepath'. this is a lot slower
                            -- library = vim.api.nvim_get_runtime_file("", true)
                        },
                    },
                },
            },
            yamlls = {},
            -- sqls = {},
            nil_ls = {
                settings = {
                    ['nil'] = {
                        formatting = {
                            command = { 'nixfmt' },
                        },
                    },
                },
            },
            taplo = {},
            jdtls = {},
            vhdl_ls = {},
            clangd = {},
        }

        -- nvim-cmp supports additional completion capabilities, so broadcast that to servers
        local defaultCapabilities = vim.lsp.protocol.make_client_capabilities()
        local capabilities = vim.tbl_deep_extend('force', defaultCapabilities, require('cmp_nvim_lsp').default_capabilities())
        capabilities.textDocument.foldingRange = {
            dynamicRegistration = false,
            lineFoldingOnly = true,
        }

        local mason_lspconfig = require 'mason-lspconfig'

        -- Ensure the servers above are installed
        local ensure_installed = vim.tbl_keys(servers or {})
        vim.list_extend(ensure_installed, {
            'stylua',
            -- 'csharpier',
            'jq',
            'prettierd',
            'eslint_d',
            'cspell',
            'js-debug-adapter',
            'debugpy',
            'shfmt',
            'shellcheck',
            'hadolint',
            'codelldb',
            'mypy',
            'clang-format',
            'java-debug-adapter',
            'java-test',
        })

        require('mason-tool-installer').setup {
            ensure_installed = ensure_installed,
        }

        mason_lspconfig.setup_handlers {
            function(server_name)
                lspconfig[server_name].setup {
                    capabilities = capabilities,
                    filetypes = (servers[server_name] or {}).filetypes,
                    settings = (servers[server_name] or {}).settings,
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

            ['jdtls'] = function() end,
        }

        -- lspconfig.ccls.setup {
        --     init_options = {
        --         cache = {
        --             directory = '.ccls-cache',
        --         },
        --         clang = {
        --             extraArgs = {
        --                 '-I/usr/local/include',
        --                 '-I/opt/homebrew/opt/llvm/bin/../include/c++/v1',
        --                 '-I/opt/homebrew/Cellar/llvm/18.1.8/lib/clang/18/include',
        --             },
        --         },
        --     },
        --
        --     -- root_dir = function()
        --     --     -- local root_files = {
        --     --     --     'compile_commands.json',
        --     --     --     '.ccls',
        --     --     --     '.git',
        --     --     -- }
        --     --     --
        --     --     -- local root = lspconfig.util.root_pattern(unpack(root_files))(filename)
        --     --     --
        --     --     -- return root == vim.fn.getcwd() and root or nil
        --     --     return vim.fn.getcwd()
        --     -- end,
        -- }

        lspconfig.dartls.setup {
            cmd = { 'dart', 'language-server', '--protocol=lsp' },
            filetypes = { 'dart' },
            root_dir = function(filename)
                return vim.fn.getcwd()
            end,
            init_options = {
                onlyAnalyzeProjectsWithOpenFiles = true,
                suggestFromUnimportedLibraries = true,
                closingLabels = true,
                outline = true,
                flutterOutline = true,
            },
            settings = {
                dart = {
                    completeFunctionCalls = true,
                    showTodos = true,
                },
            },
        }

        local trouble = require 'trouble'
        local telescope = require 'telescope.builtin'

        local on_attach = function(args)
            local client = vim.lsp.get_client_by_id(args.data.client_id)
            if client and client.name == 'ruff_lsp' then
                -- Disable hover in favor of Pyright
                client.server_capabilities.hoverProvider = false
                -- client.server_capabilities.codeActionProvider = false
            end

            local nmap = function(keys, func, desc)
                if desc then
                    desc = 'LSP: ' .. desc
                end

                vim.keymap.set('n', keys, func, { buffer = args.buf, desc = desc })
            end

            nmap('<leader>lr', vim.lsp.buf.rename, '[L]sp [R]ename')
            nmap('<leader>la', vim.lsp.buf.code_action, '[L]sp code [A]ction')
            nmap('<leader>lR', ':LspRestart <CR>', '[L]sp [R]estart')

            nmap('gd', function()
                telescope.lsp_definitions()
            end, '[G]oto [D]efinition')
            nmap('gr', function()
                trouble.toggle 'lsp_references'
            end, '[G]oto [R]eferences')

            nmap('gI', vim.lsp.buf.implementation, '[G]oto [I]mplementation')
            nmap('<leader>D', telescope.lsp_type_definitions, 'Type [D]efinition')
            nmap('<leader>ls', telescope.lsp_document_symbols, '[L]sp Document [S]ymbols')
            nmap('<leader>ws', telescope.lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

            nmap('<leader>fr', telescope.lsp_references, '[F]ind [R]eferences')
            nmap('<leader>fi', telescope.lsp_implementations, '[F]ind [I]mplementations')

            nmap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
            nmap('<leader>wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder')
            nmap('<leader>wr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove Folder')
            nmap('<leader>wl', function()
                print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
            end, '[W]orkspace [L]ist Folders')

            nmap('<leader>ih', function()
                vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
            end, '[I]nlay [H]ints')
        end

        vim.api.nvim_create_autocmd('LspAttach', {
            group = vim.api.nvim_create_augroup('UserLspConfig', { clear = true }),
            callback = on_attach,
        })
    end,
}
