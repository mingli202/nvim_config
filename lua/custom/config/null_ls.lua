local contains = function(table, value)
  for i = 1, #table do
    if table[i] == value then
      return true
    end
  end

  return false
end

local null_ls = require 'null-ls'

null_ls.setup {
  sources = {
    null_ls.builtins.diagnostics.eslint_d,
    null_ls.builtins.formatting.stylua,
    null_ls.builtins.formatting.prettierd,
    null_ls.builtins.formatting.clang_format.with {
      extra_filetypes = { 'arduino' },
    },
    null_ls.builtins.formatting.autopep8,
    null_ls.builtins.diagnostics.cspell.with {
      filetypes = { 'markdown' },
    },
    null_ls.builtins.code_actions.cspell.with {
      filetypes = { 'markdown' },
    },
  },
  root_dir = function()
    return nil
  end,
  on_attach = function(client, _)
    if client.supports_method 'textDocument/formatting' then
      local aug = vim.api.nvim_create_augroup('LspFormatting', { clear = true })
      vim.api.nvim_create_autocmd('BufWritePre', {
        group = aug,
        callback = function()
          vim.lsp.buf.format {
            name = 'null-ls',
            buffer = vim.fn.bufnr '%',
          }
        end,
      })
    end

    local ft = vim.bo.filetype
    local eslint_d = null_ls.builtins.diagnostics.eslint_d
    local prettierd = null_ls.builtins.formatting.prettierd

    if contains(eslint_d.filetypes, ft) then
      local gr = vim.api.nvim_create_augroup('EslintQuit', { clear = true })
      vim.api.nvim_create_autocmd('VimLeave', {
        group = gr,
        command = '!eslint_d stop',
      })
    end

    if contains(prettierd.filetypes, ft) then
      local gr = vim.api.nvim_create_augroup('PrettierQuit', { clear = true })
      vim.api.nvim_create_autocmd('VimLeave', {
        group = gr,
        command = '!prettierd stop',
      })
    end
  end,
}

require('mason-null-ls').setup {
  ensure_installed = {},
  automatic_installation = true,
}
