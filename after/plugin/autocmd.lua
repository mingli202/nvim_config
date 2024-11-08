-- [[ Highlight on yank ]]
-- See `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
    callback = function()
        vim.highlight.on_yank()
    end,
    group = highlight_group,
    pattern = '*',
})

-- Telescope live_grep in git root
-- Function to find the git root directory based on the current buffer's path
local function find_git_root()
    -- Use the current buffer's path as the starting point for the git search
    local current_file = vim.api.nvim_buf_get_name(0)
    local current_dir
    local cwd = vim.fn.getcwd()
    -- If the buffer is not associated with a file, return nil
    if current_file == '' then
        current_dir = cwd
    else
        -- Extract the directory from the current file's path
        current_dir = vim.fn.fnamemodify(current_file, ':h')
    end

    -- Find the Git root directory from the current file's path
    local git_root = vim.fn.systemlist('git -C ' .. vim.fn.escape(current_dir, ' ') .. ' rev-parse --show-toplevel')[1]
    if vim.v.shell_error ~= 0 then
        print 'Not a git repository. Searching on current working directory'
        return cwd
    end
    return git_root
end

-- Custom live_grep function to search in git root
local function live_grep_git_root()
    local git_root = find_git_root()
    if git_root then
        require('telescope.builtin').live_grep {
            search_dirs = { git_root },
        }
    end
end

vim.api.nvim_create_user_command('LiveGrepGitRoot', live_grep_git_root, {})

vim.api.nvim_create_user_command('CCBuild', require('util').build, {})

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
