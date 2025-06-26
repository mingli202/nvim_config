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

        -- Enable the following language servers
        --  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
        --
        --  Add any additional override configuration in the following tables. They will be passed to
        --  the `settings` field of the server config. You must look up that documentation yourself.
        --
        --  If you want to override the default filetypes that your language server will attach to you can
        --  define the property 'filetypes' to the map in question.

        local servers = {
            'html',
            'cssls',
            --'r_language_server',
            --'texlab',
            'omnisharp',
            -- 'tailwindcss',
            -- 'pyright',
            -- 'ruff',
            'vtsls',
            -- 'bashls',
            -- 'dockerls',
            'rust_analyzer',
            'lua_ls',
            -- 'yamlls',
            --'sqls',
            -- 'nil_ls',
            -- 'taplo',
            -- 'jdtls',
            -- 'clangd',
            'angularls',
        }

        -- nvim-cmp supports additional completion capabilities, so broadcast that to servers
        local defaultCapabilities = vim.lsp.protocol.make_client_capabilities()
        local capabilities = vim.tbl_deep_extend('force', defaultCapabilities, require('cmp_nvim_lsp').default_capabilities())
        capabilities.textDocument.foldingRange = {
            dynamicRegistration = false,
            lineFoldingOnly = true,
        }

        -- Ensure the servers above are installed
        local ensure_installed = vim.list_slice(servers, 0, #servers)
        vim.list_extend(ensure_installed, {
            'stylua',
            -- 'csharpier',
            -- 'jq',
            'prettierd',
            'eslint_d',
            -- 'cspell',
            'js-debug-adapter',
            -- 'debugpy',
            -- 'shfmt',
            -- 'shellcheck',
            -- 'hadolint',
            -- 'codelldb',
            --'mypy',
            -- 'clang-format',
            -- 'java-debug-adapter',
            -- 'java-test',
            'netcoredbg',
        })

        require('mason-tool-installer').setup {
            ensure_installed = ensure_installed,
        }

        vim.lsp.config('*', {
            capabilities = capabilities,
        })
        vim.lsp.config('html', {
            filetypes = { 'html', 'htmlangular' },
        })
        vim.lsp.config('vtsls', {
            root_dir = function(_, cb)
                cb(vim.fn.getcwd())
            end,
            root_markers = {},
        })
        vim.lsp.config('angularls', {
            root_dir = function(_, cb)
                cb(vim.fn.getcwd())
            end,
            root_markers = {},
        })

        vim.lsp.enable(servers)

        local trouble = require 'trouble'
        local telescope = require 'telescope.builtin'

        local isAngular = false
        local vtsls_client = nil

        local on_attach = function(args)
            local client = vim.lsp.get_client_by_id(args.data.client_id)
            if client then
                local name = client.name

                if name == 'ruff_lsp' then
                    -- Disable hover in favor of Pyright
                    client.server_capabilities.hoverProvider = false
                    client.server_capabilities.codeActionProvider = false
                elseif name == 'angularls' then
                    if vtsls_client then
                        vtsls_client.server_capabilities.renameProvider = false
                    else
                        isAngular = true
                    end
                elseif name == 'vtsls' then
                    if isAngular then
                        client.server_capabilities.renameProvider = false
                    else
                        vtsls_client = client
                    end
                end
            end

            local nmap = function(keys, func, desc)
                if desc then
                    desc = 'LSP: ' .. desc
                end

                vim.keymap.set('n', keys, func, { buffer = args.buf, desc = desc })
            end

            nmap('K', function()
                -- local border = { ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ' }
                local border = 'solid'
                vim.lsp.buf.hover { border = border }
            end, 'Lsp Hover')
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
