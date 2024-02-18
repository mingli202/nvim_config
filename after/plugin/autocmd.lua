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
    local fullPath = vim.fn.expand '%:p'
    local command = ''

    if filetype == 'javacript' then -- js
        command = string.format('node "%s"', fullPath)
    elseif filetype == 'typescript' then -- ts
        local jsFile = fullPath:gsub('.ts$', '.js', 1)
        command = string.format('tsc "%s" && node "%s" && rm -rf "%s"', fullPath, jsFile, jsFile)
    elseif filetype == 'c' then -- c
        local binary = vim.fn.expand '%:p:h' .. '/bin/' .. vim.fn.expand('%:t'):gsub('.c$', '', 1)
        command = string.format('mkdir -p "%s/bin" && clang -std=c2x "%s" -o "%s" -g && time "%s"', vim.fn.expand '%:p:h', fullPath, binary, binary)
    elseif filetype == 'cpp' then -- cpp
        local binary = vim.fn.expand '%:p:h' .. '/bin/' .. vim.fn.expand('%:t'):gsub('.cpp$', '', 1)
        command = string.format('mkdir -p "%s/bin" && clang++ -std=c++2b "%s" -o "%s" -g && time "%s"', vim.fn.expand '%:p:h', fullPath, binary, binary)
    elseif filetype == 'python' then -- py
        command = string.format('python3 -u "%s"', fullPath)
    elseif filetype == 'cs' then -- cs
        command = string.format('dotnet run "%s"', fullPath)
    elseif filetype == 'lua' then -- lua
        command = string.format('lua "%s"', fullPath)
    else
        command = 'echo "No code runner configured!"'
    end

    vim.cmd(string.format("silent !tmux splitw -h && tmux send-keys '%s' Enter", command:gsub('[%%%#]', '\\%1')))
end
vim.api.nvim_create_user_command('RunCurrentFile', run, {})
vim.api.nvim_create_user_command('CCBuild', require('custom.util').build, {})
