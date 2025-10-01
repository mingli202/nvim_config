return {
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

        'b0o/schemastore.nvim',
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

                map('g.', function()
                    vim.lsp.buf.code_action()
                end, 'Lsp Hover')

                map('gd', function()
                    Snacks.picker.lsp_definitions()
                end, '[G]oto [D]efinitions')

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

                local client = vim.lsp.get_client_by_id(event.data.client_id)
                -- The following code creates a keymap to toggle inlay hints in your
                -- code, if the language server you are using supports them
                --
                -- This may be unwanted, since they displace some of your code
                if client and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_inlayHint, event.buf) then
                    map('<leader>ih', function()
                        vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
                    end, 'Toggle [I]nlay [H]ints')
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
        capabilities.textDocument.foldingRange = {
            dynamicRegistration = false,
            lineFoldingOnly = true,
        }

        local servers = {
            clangd = {},
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
            jsonls = {
                settings = {
                    json = {
                        schemas = require('schemastore').json.schemas(),
                        validate = { enable = true },
                    },
                },
            },

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
            'oxlint',
            -- 'cspell',
            'js-debug-adapter',
            'debugpy',
            'shfmt',
            'shellcheck',
            'codelldb',
            'mypy',
            'clang-format',
            'jdtls',
            'java-debug-adapter',
            'java-test',
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
        require('ufo').setup()
    end,
}
