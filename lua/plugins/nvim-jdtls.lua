return {
    'mfussenegger/nvim-jdtls',
    dependencies = {
        'mfussenegger/nvim-dap',
    },
    config = function()
        vim.api.nvim_create_user_command('JdtJunitTest', function()
            local jdtls = require 'jdtls'
            jdtls.test_class()
        end, { desc = 'run junit tests' })
    end,
}
