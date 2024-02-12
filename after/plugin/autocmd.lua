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

-- code runner
local run = function()
    local filetype = vim.bo.ft
    local fullPath = vim.fn.expand('%:p'):gsub('[%%%#]', '\\%1')

    if filetype == 'javacript' then -- js
        vim.cmd.terminal('node "' .. fullPath .. '"')
    elseif filetype == 'typescript' then --ts
        local jsFile = fullPath:gsub('.ts$', '.js', 1)
        vim.cmd.terminal('tsc "' .. fullPath .. '" && node "' .. jsFile .. '" && rm -rf "' .. jsFile .. '"')
    elseif filetype == 'c' then -- c
        require('custom.util').build()
        local binary = vim.fn.expand '%:p:h' .. '/bin/' .. vim.fn.expand('%:t'):gsub('.c$', '', 1)
        vim.cmd.terminal('time "' .. binary .. '"')
    elseif filetype == 'cpp' then -- cpp
        require('custom.util').build()
        local binary = vim.fn.expand '%:p:h' .. '/bin/' .. vim.fn.expand('%:t'):gsub('.cpp$', '', 1)
        vim.cmd.terminal('time "' .. binary .. '"')
    elseif filetype == 'python' then -- py
        vim.cmd.terminal('python -u "' .. fullPath .. '"')
    elseif filetype == 'cs' then -- cs
        vim.cmd.terminal('dotnet run "' .. fullPath .. '"')
    elseif filetype == 'lua' then -- lua
        vim.cmd.terminal('lua "' .. fullPath .. '"')
    else
        vim.cmd.echo '"No code runner configured!"'
    end
end
vim.api.nvim_create_user_command('RunCurrentFile', run, {})
vim.api.nvim_create_user_command('CCBuild', require('custom.util').build, {})
