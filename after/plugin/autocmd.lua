vim.api.nvim_create_autocmd('TextYankPost', {
    desc = 'Highlight when yanking (copying) text',
    group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
    callback = function()
        vim.hl.on_yank()
    end,
})

-- have to check if eslint_d and prettierd are running
-- because they are separate binaries that have to be shut down manually
-- they will run when the filetype matches their configured filetypes
vim.api.nvim_create_autocmd('FileType', {
    group = vim.api.nvim_create_augroup('CheckFtChange', { clear = true }),
    callback = function()
        local ft = vim.bo.filetype
        local eslint_d = { 'javascript', 'javascriptreact', 'typescript', 'typescriptreact', 'vue' }
        local prettierd = {
            'javascript',
            'javascriptreact',
            'typescript',
            'typescriptreact',
            'vue',
            'css',
            'scss',
            'less',
            'html',
        }

        local contains = require('util').contains

        if contains(eslint_d, ft) then
            local gr = vim.api.nvim_create_augroup('EslintQuit', { clear = true })
            vim.api.nvim_create_autocmd('VimLeave', {
                group = gr,
                command = '!eslint_d stop',
            })
        end

        if contains(prettierd, ft) then
            local gr = vim.api.nvim_create_augroup('PrettierQuit', { clear = true })
            vim.api.nvim_create_autocmd('VimLeave', {
                group = gr,
                command = '!prettierd stop',
            })
        end
    end,
})

-- enable spelling
vim.api.nvim_create_user_command('SpellToggle', function()
    if vim.o.spell then
        vim.cmd 'set nospell'
    else
        vim.cmd 'setlocal spell spelllang=en_ca'
    end
end, { desc = 'toggle spelling' })

-- save folds
local rememberFolds = vim.api.nvim_create_augroup('RememberFolds', { clear = true })
vim.api.nvim_create_autocmd('BufWinLeave', {
    group = rememberFolds,
    desc = 'save folds',
    pattern = '*.*',
    command = 'mkview',
})
vim.api.nvim_create_autocmd('BufWinEnter', {
    group = rememberFolds,
    pattern = '*.*',
    desc = 'load folds',
    command = 'silent! loadview',
})

vim.api.nvim_create_autocmd('FileType', {
    group = vim.api.nvim_create_augroup('UserFiletypeTabWidth', { clear = true }),
    callback = function()
        local twoSpacesFiletypes = {
            'javascript',
            'typescript',
            'typescriptreact',
            'vue',
            'css',
            'scss',
            'less',
            'html',
            'json',
            'yaml',
            'markdown',
            'markdown_inline',
            'jsonc',
            'json5',
        }

        if vim.tbl_contains(twoSpacesFiletypes, vim.bo.filetype) then
            vim.opt.tabstop = 2
            vim.opt.softtabstop = 2
            vim.opt.shiftwidth = 2
        else
            vim.opt.tabstop = 4
            vim.opt.softtabstop = 4
            vim.opt.shiftwidth = 4
        end
    end,
})
