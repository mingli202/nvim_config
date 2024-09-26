---helper function
---@param table table
---@param value any
---@return boolean
local contains = function(table, value)
    for i = 1, #table do
        if table[i] == value then
            return true
        end
    end

    return false
end

-- for c and cpp
local build = function()
    local filetype = vim.bo.ft
    local fullPath = vim.fn.expand '%:p'
    local directory = vim.fn.expand '%:p:h'
    local binary = directory .. '/bin/' .. vim.fn.expand('%:t'):gsub(string.format('.%s$', filetype), '', 1)

    if filetype == 'cpp' then
        vim.cmd(string.format('silent !mkdir -p "%s/bin" && clang++ -std=c++2b "%s" -o "%s" -g', directory, fullPath, binary):gsub('[%%%#]', '\\%1'))
    elseif filetype == 'c' then
        vim.cmd(string.format('silent !mkdir -p "%s/bin" && clang -std=c2x "%s" -o "%s" -g', directory, fullPath, binary):gsub('[%%%#]', '\\%1'))
    else
        vim.notify 'Wrong filetype'
    end
end

---helper function
---@param mode string | table
---@param key string
---@param cmd string | function
---@param opts table | nil
local map = function(mode, key, cmd, opts)
    local default = { noremap = true, silent = true }
    vim.keymap.set(mode, key, cmd, vim.tbl_extend('force', default, opts or {}))
end

-- code runner
local run = function(custom)
    local filetype = vim.bo.ft
    local fullPath = vim.fn.expand '%:p'
    local command = ''

    if custom ~= nil then
        command = custom
    elseif filetype == 'javascript' or filetype == 'typescript' then -- js
        command = string.format('bun run "%s"', fullPath)
    elseif filetype == 'c' then -- c
        local binary = vim.fn.expand '%:p:h' .. '/bin/' .. vim.fn.expand('%:t'):gsub('.c$', '', 1)
        command = string.format('mkdir -p "%s/bin" && clang -std=c2x "%s" -o "%s" -g && "%s"', vim.fn.expand '%:p:h', fullPath, binary, binary)
    elseif filetype == 'cpp' then -- cpp
        local binary = vim.fn.expand '%:p:h' .. '/bin/' .. vim.fn.expand('%:t'):gsub('.cpp$', '', 1)
        command = string.format('mkdir -p "%s/bin" && clang++ -std=c++2b "%s" -o "%s" -g && "%s"', vim.fn.expand '%:p:h', fullPath, binary, binary)
    elseif filetype == 'python' then -- py
        local cwd = vim.fn.getcwd()
        local py = '/opt/homebrew/bin/python3'

        if vim.fn.executable(cwd .. '/venv/bin/python') == 1 then
            py = cwd .. '/venv/bin/python'
        elseif vim.fn.executable(cwd .. '/.venv/bin/python') == 1 then
            py = cwd .. '/.venv/bin/python'
        end

        command = string.format('"%s" -u "%s"', py, fullPath)
    elseif filetype == 'cs' then -- cs
        command = string.format('dotnet run --project "%s"', vim.fn.expand '%:p:h')
    elseif filetype == 'lua' then -- lua
        command = string.format('lua "%s"', fullPath)
    elseif filetype == 'r' then -- r
        command = string.format('Rscript "%s"', fullPath)
    elseif filetype == 'rust' then -- rs
        command = string.format 'cargo run -q'
    elseif filetype == 'sh' then -- bash
        command = fullPath
    elseif filetype == 'nix' then
        command = string.format('nix-instantiate --eval "%s"', fullPath)
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

return { build = build, contains = contains, map = map, run = run }
