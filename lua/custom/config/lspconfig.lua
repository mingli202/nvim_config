-- mason-lspconfig requires that these setup functions are called in this order
-- before setting up the servers.
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
    pyright = {},
    rust_analyzer = {},
    tsserver = {},
    html = { filetypes = { 'html', 'twig', 'hbs' } },
    cssls = {},
    arduino_language_server = {
        cmd = {
            'arduino-language-server',
            '-clangd',
            '/opt/homebrew/Cellar/llvm/17.0.6_1/bin/clangd',
            '-cli',
            '/opt/homebrew/Cellar/arduino-cli/0.35.2/bin/arduino-cli',
            '-cli-config',
            '/Users/vincentliu/Library/Arduino15/arduino-cli.yaml',
            '-fqbn',
            'arduino:avr:uno',
        },
    },

    tailwindcss = {
        filetypes = {
            'javacript',
            'javascriptreact',
            'typescript',
            'typescriptreact',
        },
        root_files = {
            'tailwind.config.js',
            'tailwind.config.cjs',
            'tailwind.config.mjs',
            'tailwind.config.ts',
            'postcss.config.js',
            'postcss.config.cjs',
            'postcss.config.mjs',
            'postcss.config.ts',
        },
    },

    lua_ls = {
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
    },

    marksman = {},
}

-- Setup neovim lua configuration
require('neodev').setup()

-- nvim-cmp supports additional completion capabilities, so broadcast that to servers
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)
capabilities.offsetEncoding = 'utf-8'

-- Ensure the servers above are installed
local mason_lspconfig = require 'mason-lspconfig'

mason_lspconfig.setup {
    ensure_installed = vim.tbl_keys(servers),
}

mason_lspconfig.setup_handlers {
    function(server_name)
        lspconfig[server_name].setup {
            root_dir = function(filename)
                local root_files = servers[server_name].root_files

                if root_files == nil then
                    return vim.fn.getcwd()
                end

                local root = lspconfig.util.root_pattern(unpack(root_files))(filename)

                return root == vim.fn.getcwd() and root or nil
            end,
            capabilities = capabilities,
            on_attach = require('custom.util').on_attach,
            settings = servers[server_name].settings,
            filetypes = (servers[server_name] or {}).filetypes,
            cmd = servers[server_name].cmd,
        }
    end,
}
