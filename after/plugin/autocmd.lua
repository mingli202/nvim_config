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

    if filetype == 'javascript' then -- js
        command = string.format('/usr/bin/time node "%s"', fullPath)
    elseif filetype == 'typescript' then -- ts
        local jsFile = fullPath:gsub('.ts$', '.js', 1)
        command = string.format('tsc "%s" && /usr/bin/time node "%s" && rm -rf "%s"', fullPath, jsFile, jsFile)
    elseif filetype == 'c' then -- c
        local binary = vim.fn.expand '%:p:h' .. '/bin/' .. vim.fn.expand('%:t'):gsub('.c$', '', 1)
        command = string.format('mkdir -p "%s/bin" && clang -std=c2x "%s" -o "%s" -g && /usr/bin/time "%s"', vim.fn.expand '%:p:h', fullPath, binary, binary)
    elseif filetype == 'cpp' then -- cpp
        local binary = vim.fn.expand '%:p:h' .. '/bin/' .. vim.fn.expand('%:t'):gsub('.cpp$', '', 1)
        command =
            string.format('mkdir -p "%s/bin" && clang++ -std=c++2b "%s" -o "%s" -g && /usr/bin/time "%s"', vim.fn.expand '%:p:h', fullPath, binary, binary)
    elseif filetype == 'python' then -- py
        command = string.format('/usr/bin/time python3 -u "%s"', fullPath)
    elseif filetype == 'cs' then -- cs
        command = string.format('/usr/bin/time dotnet run "%s"', fullPath)
    elseif filetype == 'lua' then -- lua
        command = string.format('/usr/bin/time lua "%s"', fullPath)
    elseif filetype == 'r' then -- r
        command = string.format('/usr/bin/time Rscript "%s"', fullPath)
    elseif filetype == 'rust' then -- rs
        command = string.format '/usr/bin/time cargo run -q'
    else
        vim.cmd.echo '"No runner configured!"'
        return
    end
    -- check if tmux is attached
    -- if it's not then run command in a new terminal
    if vim.fn.system('echo $TMUX'):len() == 1 then
        vim.cmd.terminal(string.format('%s', command:gsub('[%%%#]', '\\%1')))
        return
    end

    -- check if a second pane is open
    -- if open then send keys to the pane
    -- else open new pane and send keys to new pane
    local panes = vim.fn.systemlist 'tmux list-panes -F "#{pane_active}"'

    -- if number of panes if 1, then make a new pane
    if #panes == 1 then
        vim.cmd(string.format("silent !tmux split-window -h -d && tmux send-keys -t2 '%s' Enter", command:gsub('[%%%#]', '\\%1')))
        return
    end

    -- else send command to next pane
    local inactiveIndex = 1

    for i, v in ipairs(panes) do
        -- '0' means inactive
        if v == '0' then
            inactiveIndex = i
            break
        end
    end

    vim.cmd(string.format("silent !tmux send-keys -t %i '%s' Enter", inactiveIndex, command:gsub('[%%%#]', '\\%1')))
end
vim.api.nvim_create_user_command('RunCurrentFile', run, {})
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

-- lspAttach
vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('UserLspConfig', { clear = true }),
    callback = require('util').on_attach,
})
