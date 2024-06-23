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
            r_language_server = {},
            texlab = {},
            rust_analyzer = {},
            omnisharp = {},
            clangd = {},
            lua_ls = {},
            tailwindcss = {},
            pyright = {},
            vtsls = {},
            bashls = {},
            grammarly = { filetypes = { 'norg' } },
            ruff = {},
            dockerls = {},
        }

        -- nvim-cmp supports additional completion capabilities, so broadcast that to servers
        local defaultCapabilities = vim.lsp.protocol.make_client_capabilities()
        local capabilities = require('cmp_nvim_lsp').default_capabilities(defaultCapabilities)
        capabilities.textDocument.foldingRange = {
            dynamicRegistration = false,
            lineFoldingOnly = true,
        }

        local mason_lspconfig = require 'mason-lspconfig'

        -- Ensure the servers above are installed
        local ensure_installed = vim.tbl_keys(servers or {})
        vim.list_extend(
            ensure_installed,
            { 'stylua', 'csharpier', 'jq', 'prettierd', 'eslint_d', 'cspell', 'js-debug-adapter', 'debugpy', 'shfmt', 'shellcheck', 'hadolint' }
        )

        require('mason-tool-installer').setup {
            ensure_installed = ensure_installed,
        }

        mason_lspconfig.setup_handlers {
            function(server_name)
                lspconfig[server_name].setup {
                    capabilities = capabilities,
                    filetypes = (servers[server_name] or {}).filetypes,
                }
            end,
            ['clangd'] = function()
                local c = require('cmp_nvim_lsp').default_capabilities(defaultCapabilities)
                c.offsetEncoding = 'utf-8'
                c.textDocument.foldingRange = {
                    dynamicRegistration = false,
                    lineFoldingOnly = true,
                }
                lspconfig.clangd.setup {
                    filetypes = { 'c', 'cpp', 'arduino' },
                    capabilities = c,
                }
            end,
            ['lua_ls'] = function()
                lspconfig.lua_ls.setup {
                    capabilities = capabilities,
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
        }

        local trouble = require 'trouble'
        local telescope = require 'telescope.builtin'

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

            -- Lesser used LSP functionality
            nmap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
            nmap('<leader>wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder')
            nmap('<leader>wr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove Folder')
            nmap('<leader>wl', function()
                print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
            end, '[W]orkspace [L]ist Folders')
        end

        vim.api.nvim_create_autocmd('LspAttach', {
            group = vim.api.nvim_create_augroup('UserLspConfig', { clear = true }),
            callback = on_attach,
        })
    end,
}
