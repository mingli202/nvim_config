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

dap.listeners.after['event_initialized']['myConfig'] = dapui.open
dap.listeners.before['event_exited']['myConfig'] = dapui.close
dap.listeners.before['event_terminated']['myConfig'] = dapui.close

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
  },
}
dap.configurations.c = dap.configurations.cpp

dapui.setup()
