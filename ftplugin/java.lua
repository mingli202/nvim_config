local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ':p:h:t')

local cmd = string.format('echo -n "%s" | openssl sha256 | cut -d" " -f 2', vim.fn.fnamemodify(vim.fn.getcwd(), ':p:h'))
local pwd_hash = string.sub(vim.fn.system(cmd), 0, 10)

local workspace_dir = vim.fn.expand('~/.cache/jdtls/workspace/' .. project_name .. '-' .. pwd_hash)

-- See `:help vim.lsp.start` for an overview of the supported `config` options.
local config = {
    name = 'jdtls',

    -- `cmd` defines the executable to launch eclipse.jdt.ls.
    -- `jdtls` must be available in $PATH and you must have Python3.9 for this to work.
    --
    -- As alternative you could also avoid the `jdtls` wrapper and launch
    -- eclipse.jdt.ls via the `java` executable
    -- See: https://github.com/eclipse/eclipse.jdt.ls#running-from-the-command-line
    cmd = { 'jdtls', '-data', workspace_dir },

    -- `root_dir` must point to the root of your project.
    -- See `:help vim.fs.root`
    root_dir = vim.fs.root(0, { 'gradlew', '.git', 'mvnw' }),

    -- Here you can configure eclipse.jdt.ls specific settings
    -- See https://github.com/eclipse/eclipse.jdt.ls/wiki/Running-the-JAVA-LS-server-from-the-command-line#initialize-request
    -- for a list of options
    settings = {
        java = {},
    },

    -- This sets the `initializationOptions` sent to the language server
    -- If you plan on using additional eclipse.jdt.ls plugins like java-debug
    -- you'll need to set the `bundles`
    --
    -- See https://codeberg.org/mfussenegger/nvim-jdtls#java-debug-installation
    --
    -- If you don't plan on any eclipse.jdt.ls plugins you can remove this
    init_options = {
        bundles = {},
    },
}

local bundles = {
    vim.fn.glob('/Users/vincentliu/.local/share/nvim/mason/packages/java-debug-adapter/extension/server/com.microsoft.java.debug.plugin-*.jar', 1),
}

local java_test_bundles = vim.split(vim.fn.glob('/Users/vincentliu/.local/share/nvim/mason/packages/java-test/extension/server/*.jar', 1), '\n')

local excluded = {
    'com.microsoft.java.test.runner-jar-with-dependencies.jar',
    'jacocoagent.jar',
}
for _, java_test_jar in ipairs(java_test_bundles) do
    local fname = vim.fn.fnamemodify(java_test_jar, ':t')
    if not vim.tbl_contains(excluded, fname) then
        table.insert(bundles, java_test_jar)
    end
end

config['init_options'] = { bundles = bundles }

require('jdtls').start_or_attach(config)
