return {
    'mfussenegger/nvim-jdtls',
    dependencies = {
        'mfussenegger/nvim-dap',
    },
    config = function()
        vim.api.nvim_create_user_command('JdtJunitTest', function()
            local name = 'junit-platform-console-standalone.jar'

            if not vim.fn.findfile(name, './lib') then
                vim.cmd(
                    '!curl -o lib/'
                        .. name
                        .. 'https://repo1.maven.org/maven2/org/junit/platform/junit-platform-console-standalone/1.11.4/junit-platform-console-standalone-1.11.4.jar'
                )
            end

            local jdtls = require 'jdtls'
            jdtls.test_class()
        end, { desc = 'run junit tests' })
    end,
}
