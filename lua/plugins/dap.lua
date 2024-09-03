return {
    'mfussenegger/nvim-dap',
    dependencies = {
        { 'rcarriga/nvim-dap-ui', dependencies = { 'nvim-neotest/nvim-nio' } },
    },
    event = 'VeryLazy',
    config = function()
        local dap = require 'dap'
        local dapui = require 'dapui'
        local map = require('util').map

        map('n', '<F4>', dap.restart, { desc = 'debug: restart adapter' })
        map('n', '<F5>', dap.continue, { desc = 'debug: start/continue' })
        map('n', '<F6>', dap.terminate, { desc = 'debug: terminate' })
        map('n', '<leader>b', dap.toggle_breakpoint, { desc = 'toggle [B]reakpoint' })

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
        dap.adapters.codelldb = {
            type = 'server',
            port = '${port}',
            executable = {
                command = vim.fn.exepath 'codelldb',
                args = { '--port', '${port}' },
            },
        }
        dap.configurations.cpp = {
            {
                name = 'Launch',
                type = 'codelldb',
                request = 'launch',
                program = function()
                    require('util').build()

                    return '${fileDirname}/bin/${fileBasenameNoExtension}'
                end,
                cwd = '${workspaceFolder}',
                stopOnEntry = false,
                args = {},
                console = 'integratedTerminal',
            },
        }
        dap.configurations.c = dap.configurations.cpp

        dap.configurations.rust = {
            {
                name = 'Launch',
                type = 'codelldb',
                request = 'launch',
                program = function()
                    vim.cmd '!cargo build'

                    local bin = vim.fn.getcwd():gsub('.+/', '')
                    return string.format('${workspaceFolder}/target/debug/%s', bin)
                end,
                cwd = '${workspaceFolder}',
                stopOnEntry = false,
                args = {},
                console = 'integratedTerminal',
            },
        }

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

        dap.adapters['pwa-node'] = {
            type = 'server',
            host = 'localhost',
            port = '${port}',
            executable = {
                command = 'node',
                -- 💀 Make sure to update this path to point to your installation
                args = { '/Users/vincentliu/.local/share/nvim/mason/packages/js-debug-adapter/js-debug/src/dapDebugServer.js', '${port}' },
            },
        }
        dap.configurations.javascript = {
            {
                type = 'pwa-node',
                request = 'launch',
                name = 'Launch file',
                program = '${file}',
                cwd = '${workspaceFolder}',
            },
        }

        dapui.setup()
    end,
}
