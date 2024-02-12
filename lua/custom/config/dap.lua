local dap = require 'dap'
local dapui = require 'dapui'

require('mason-nvim-dap').setup {
    ensured_installed = { 'python', 'js' },
    automatic_installation = false,
    handlers = {
        function(config)
            -- all sources with no handler get passed here

            -- Keep original functionality
            require('mason-nvim-dap').default_setup(config)
        end,
    },
}

dap.listeners.after['event_initialized']['myConfig'] = function()
    dapui.open()
    vim.keymap.set('n', '<Right>', dap.step_over, { desc = 'debug: step over', silent = true })
    vim.keymap.set('n', '<Left>', dap.step_back, { desc = 'debug: step back', silent = true })
    vim.keymap.set('n', '<Down>', dap.step_into, { desc = 'debug: step into', silent = true })
    vim.keymap.set('n', '<Up>', dap.step_out, { desc = 'debug: step out', silent = true })
end

local onClose = function()
    dapui.close()
    vim.keymap.set('n', '<Right>', '<Right>')
    vim.keymap.set('n', '<Left>', '<Left>')
    vim.keymap.set('n', '<Down>', '<Down>')
    vim.keymap.set('n', '<Up>', '<Up>')
end

dap.listeners.before['event_exited']['myConfig'] = onClose
dap.listeners.before['event_terminated']['myConfig'] = onClose

-- c/cpp
dap.adapters.lldb = {
    type = 'executable',
    command = '/opt/homebrew/Cellar/llvm/17.0.6_1/bin/lldb-vscode', -- adjust as needed, must be absolute path
    name = 'lldb',
}
dap.configurations.cpp = {
    {
        name = 'Launch',
        type = 'lldb',
        request = 'launch',
        program = function()
            require('custom.util').build()

            return '${fileDirname}/bin/${fileBasenameNoExtension}'
        end,
        cwd = '${workspaceFolder}',
        stopOnEntry = false,
        args = {},
        runInTerminal = true,
    },
}
dap.configurations.c = dap.configurations.cpp

dapui.setup()
