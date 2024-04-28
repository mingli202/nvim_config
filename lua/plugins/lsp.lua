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
            tsserver = {},
            html = { filetypes = { 'html', 'twig', 'hbs' } },
            cssls = {},
            marksman = {},
            r_language_server = {},
            texlab = {},
            rust_analyzer = {},
        }

        -- Setup neovim lua configuration
        require('neodev').setup()

        -- nvim-cmp supports additional completion capabilities, so broadcast that to servers
        local defaultCapabilities = vim.lsp.protocol.make_client_capabilities()
        local capabilities = require('cmp_nvim_lsp').default_capabilities(defaultCapabilities)
        capabilities.textDocument.foldingRange = {
            dynamicRegistration = false,
            lineFoldingOnly = true,
        }

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
            ['omnisharp'] = function()
                lspconfig.omnisharp.setup {
                    capabilities = capabilities,
                }
            end,
            ['clangd'] = function()
                local defaultCapabilities = vim.lsp.protocol.make_client_capabilities()
                local c = require('cmp_nvim_lsp').default_capabilities(defaultCapabilities)
                c.offsetEncoding = 'utf-8'
                c.textDocument.foldingRange = {
                    dynamicRegistration = false,
                    lineFoldingOnly = true,
                }
                lspconfig.clangd.setup {
                    filetypes = { 'c', 'cpp', 'arduino' },
                    capabilities = c,
                    root_dir = function()
                        return vim.fn.getcwd()
                    end,
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
            ['pylsp'] = function()
                lspconfig.pylsp.setup {
                    capabilities = capabilities,
                    settings = {
                        pylsp = {
                            plugins = {
                                jedi = {
                                    environment = '/opt/homebrew/bin/python3',
                                },
                            },
                        },
                    },
                    root_dir = function()
                        return vim.fn.getcwd()
                    end,
                }
            end,
        }

        -- lspAttach

        -- [[ Configure LSP ]]
        --  This function gets run when an LSP connects to a particular buffer.
        -- NOTE: Remember that lua is a real programming language, and as such it is possible
        -- to define small helper and utility functions so you don't have to repeat yourself
        -- many times.
        -- In this case, we create a function that lets us more easily define mappings specific
        -- for LSP related items. It sets the mode, buffer and description for us each time.
        local formatters = {
            ['null-ls'] = true,
            r_language_server = true,
        }

        local trouble = require 'trouble'
        local telescope = require 'telescope.builtin'
        local contains = require('util').contains

        local on_attach = function(args)
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

            -- See `:help K` for why this keymap
            nmap('K', vim.lsp.buf.hover, 'Hover Documentation')

            -- Lesser used LSP functionality
            nmap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
            nmap('<leader>wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder')
            nmap('<leader>wr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove Folder')
            nmap('<leader>wl', function()
                print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
            end, '[W]orkspace [L]ist Folders')

            -- autoformat for null-ls
            -- all my formatters come from null_ls
            -- so make null_ls the primary source of formatting
            local client = vim.lsp.get_client_by_id(args.data.client_id)
            if client.supports_method 'textDocument/formatting' then
                local aug = vim.api.nvim_create_augroup('LspFormatting', { clear = true })
                vim.api.nvim_create_autocmd('BufWritePre', {
                    group = aug,
                    callback = function()
                        vim.lsp.buf.format {
                            -- format only from null_ls or any other exceptions
                            filter = function(cl)
                                return formatters[cl.name]
                            end,
                            buffer = args.buf, -- format current buffer
                        }
                    end,
                })
            end

            -- -- have to check if eslint_d and prettierd are running
            -- -- because they are separate binaries that have to be shut down manually
            -- -- they will run when the filetype matches their configured filetypes
            local ft = vim.bo.filetype
            local eslint_d = { 'javascript', 'javascriptreact', 'typescript', 'typescriptreact', 'vue' }
            local prettierd = {
                'javascript',
                'javascriptreact',
                'typescript',
                'typescriptreact',
                'vue',
                'css',
                'scss',
                'less',
                'html',
                'json',
                'jsonc',
                'yaml',
                'markdown',
                'markdown.mdx',
                'graphql',
                'handlebars',
            }

            if contains(eslint_d, ft) then
                local gr = vim.api.nvim_create_augroup('EslintQuit', { clear = true })
                vim.api.nvim_create_autocmd('VimLeave', {
                    group = gr,
                    command = '!eslint_d stop',
                })
            end

            if contains(prettierd, ft) then
                local gr = vim.api.nvim_create_augroup('PrettierQuit', { clear = true })
                vim.api.nvim_create_autocmd('VimLeave', {
                    group = gr,
                    command = '!prettierd stop',
                })
            end
        end

        vim.api.nvim_create_autocmd('LspAttach', {
            group = vim.api.nvim_create_augroup('UserLspConfig', { clear = true }),
            callback = on_attach,
        })
    end,
}
