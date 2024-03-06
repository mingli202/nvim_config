return {
    'mfussenegger/nvim-dap',
    dependencies = {
        'rcarriga/nvim-dap-ui',
    },
    config = function()
        local dap = require 'dap'
        local dapui = require 'dapui'

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
            command = '/opt/homebrew/opt/llvm/bin/lldb-vscode', -- adjust as needed, must be absolute path
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

        -- python
        dap.adapters.python = {
            type = 'executable',
            command = vim.fn.exepath 'debugpy-adapter',
        }
        dap.configurations.python = {
            {
                -- The first three options are required by nvim-dap
                type = 'python', -- the type here established the link to the adapter definition: `dap.adapters.python`
                request = 'launch',
                name = 'Python: launch file',

                -- Options below are for debugpy, see https://github.com/microsoft/debugpy/wiki/Debug-configuration-settings for supported options

                program = '${file}', -- This configuration will launch the current file if used.
                pythonPath = function()
                    -- debugpy supports launching an application with a different interpreter then the one used to launch debugpy itself.
                    -- The code below looks for a `venv` or `.venv` folder in the current directly and uses the python within.
                    -- You could adapt this - to for example use the `VIRTUAL_ENV` environment variable.
                    local cwd = vim.fn.getcwd()
                    if vim.fn.executable(cwd .. '/venv/bin/python') == 1 then
                        return cwd .. '/venv/bin/python'
                    elseif vim.fn.executable(cwd .. '/.venv/bin/python') == 1 then
                        return cwd .. '/.venv/bin/python'
                    else
                        return '/opt/homebrew/bin/python3'
                    end
                end,
                console = 'integratedTerminal',
            },
        }

        dapui.setup()
    end,
}
