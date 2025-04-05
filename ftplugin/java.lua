local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ':p:h:t')

local home = vim.fn.expand '~'
local workspace_dir = home .. '/.cache/jdtls/workspace/' .. project_name
-- local workspace_dir = vim.fn.getcwd() .. '/.cache/jdtls/workspace'

-- 'path/to/java-debug/com.microsoft.java.debug.plugin/target/com.microsoft.java.debug.plugin-*.jar'
-- /Users/vincentliu/.local/share/nvim/mason/share/java-debug-adapter/com.microsoft.java.debug.plugin.jar
local bundles =
    { vim.fn.glob '/Users/vincentliu/.local/share/nvim/mason/packages/java-debug-adapter/extension/server/com.microsoft.java.debug.plugin-0.53.1.jar' }

-- '/path/to/microsoft/vscode-java-test/server/*.jar'
-- ~/.local/share/nvim/mason/packages/java-test/extension/server/*.jar
vim.list_extend(bundles, vim.split(vim.fn.glob('/Users/vincentliu/.local/share/nvim/mason/packages/java-test/extension/server/*.jar', 1), '\n'))

-- See `:help vim.lsp.start_client` for an overview of the supported `config` options.
local config = {
    -- The command that starts the language server
    -- See: https://github.com/eclipse/eclipse.jdt.ls#running-from-the-command-line
    cmd = {

        -- 💀
        'java', -- or '/path/to/java21_or_newer/bin/java'
        -- depends on if `java` is in your $PATH env variable and if it points to the right version.

        '-Declipse.application=org.eclipse.jdt.ls.core.id1',
        '-Dosgi.bundles.defaultStartLevel=4',
        '-Declipse.product=org.eclipse.jdt.ls.core.product',
        '-Dlog.protocol=true',
        '-Dlog.level=ALL',
        '-Xmx1g',
        '--add-modules=ALL-SYSTEM',
        '--add-opens',
        'java.base/java.util=ALL-UNNAMED',
        '--add-opens',
        'java.base/java.lang=ALL-UNNAMED',

        -- '-javaagent:' .. vim.fn.expand '~/.local/share/nvim/mason/packages/jdtls/lombok.jar',

        -- 💀
        '-jar',
        --'/path/to/jdtls_install_location/plugins/org.eclipse.equinox.launcher_VERSION_NUMBER.jar',
        -- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^                                       ^^^^^^^^^^^^^^
        -- Must point to the                                                     Change this to
        -- eclipse.jdt.ls installation                                           the actual version
        vim.fn.expand '/Users/vincentliu/.local/share/nvim/mason/packages/jdtls/plugins/org.eclipse.equinox.launcher_1.6.900.v20240613-2009.jar',
        -- ~/.local/share/nvim/mason/packages/jdtls/plugins/org.eclipse.equinox.launcher_1.6.900.v20240613-2009.jar

        -- 💀
        '-configuration',
        -- '/path/to/jdtls_install_location/config_SYSTEM',
        -- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^        ^^^^^^
        -- Must point to the                      Change to one of `linux`, `win` or `mac`
        -- eclipse.jdt.ls installation            Depending on your system.
        home .. '/.local/share/nvim/mason/packages/jdtls/config_mac',
        -- '/nix/store/95fqm36gn4pm0kw85wbw357phxbdpdd5-jdt-language-server-1.43.0/share/java/jdtls/config_mac',

        -- 💀
        -- See `data directory configuration` section in the README
        '-data',
        workspace_dir,
    },

    -- 💀
    -- This is the default if not provided, you can remove it. Or adjust as needed.
    -- One dedicated LSP server & client will be started per unique root_dir
    --
    -- vim.fs.root requires Neovim 0.10.
    -- If you're using an earlier version, use: require('jdtls.setup').find_root({'.git', 'mvnw', 'gradlew'}),
    root_dir = vim.fs.root(0, { '.git', 'mvnw', 'gradlew', 'pom.xml', 'README.md' }),

    -- Here you can configure eclipse.jdt.ls specific settings
    -- See https://github.com/eclipse/eclipse.jdt.ls/wiki/Running-the-JAVA-LS-server-from-the-command-line#initialize-request
    -- for a list of options
    settings = {
        java = {
            signatureHelp = { enabled = true },
            extendedClientCapabilities = require('jdtls').extendedClientCapabilities,
        },
    },

    -- Language server `initializationOptions`
    -- You need to extend the `bundles` with paths to jar files
    -- if you want to use additional eclipse.jdt.ls plugins.
    --
    -- See https://github.com/mfussenegger/nvim-jdtls#java-debug-installation
    --
    -- If you don't plan on using the debugger or other eclipse.jdt.ls plugins you can remove this
    init_options = {
        bundles = bundles,
    },
}
-- This starts a new client & server,
-- or attaches to an existing client & server depending on the `root_dir`.
require('jdtls').start_or_attach(config)
