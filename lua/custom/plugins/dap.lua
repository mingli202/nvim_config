return {
  'mfussenegger/nvim-dap',
  dependencies = {
    'williamboman/mason.nvim',
    'jay-babu/mason-nvim-dap.nvim',
    'rcarriga/nvim-dap-ui',
    'ChristianChiarulli/neovim-codicons',
  },
  config = function()
    require 'custom.config.dap'
  end,
}
