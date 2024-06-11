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
    local t1 = { noremap = true, silent = true }

    if opts ~= nil then
        for k, v in pairs(opts) do
            t1[k] = v
        end
    end

    vim.keymap.set(mode, key, cmd, t1)
end

-- code runner
local run = function(custom)
    local filetype = vim.bo.ft
    local fullPath = vim.fn.expand '%:p'
    local command = ''

    if custom ~= nil then
        command = custom
    elseif filetype == 'javascript' then -- js
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
        command = string.format('/usr/bin/time dotnet run --project "%s"', vim.fn.expand '%:p:h')
    elseif filetype == 'lua' then -- lua
        command = string.format('/usr/bin/time lua "%s"', fullPath)
    elseif filetype == 'r' then -- r
        command = string.format('/usr/bin/time Rscript "%s"', fullPath)
    elseif filetype == 'rust' then -- rs
        command = string.format '/usr/bin/time cargo run -q'
    elseif filetype == 'sh' then -- bash
        command = fullPath
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
