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
    elseif vim.fn.getenv 'CMD' ~= vim.NIL then
        command = vim.fn.getenv 'CMD'
    elseif filetype == 'javascript' or filetype == 'typescript' then -- js
        command = string.format('bun run "%s"', fullPath)
    elseif filetype == 'c' then -- c
        local binary = vim.fn.expand '%:p:h' .. '/bin/' .. vim.fn.expand('%:t'):gsub('.c$', '', 1)
        command = string.format('mkdir -p "%s/bin" && clang -std=c2x "%s" -o "%s" -g && "%s"', vim.fn.expand '%:p:h', fullPath, binary, binary)
    elseif filetype == 'cpp' then -- cpp
        local binary = vim.fn.expand '%:p:h' .. '/bin/' .. vim.fn.expand('%:t'):gsub('.cpp$', '', 1)
        command = string.format('mkdir -p "%s/bin" && clang++ -std=c++2b "%s" -o "%s" -g && "%s"', vim.fn.expand '%:p:h', fullPath, binary, binary)
    elseif filetype == 'python' then -- py
        local py = '/opt/homebrew/bin/python3'

        if vim.fn.executable 'python' == 1 then
            py = vim.fn.exepath 'python'
        elseif vim.fn.executable 'python3' == 1 then
            py = vim.fn.exepath 'python3'
        end

        local cwd = vim.fn.getcwd() .. '/'

        local module = ''
        if fullPath:sub(1, #cwd) == cwd then
            -- Subtract the CWD part
            module = fullPath:sub(#cwd + 1)
        else
            vim.notify 'File not in the CWD'
            return
        end

        module = module:gsub('.py', '', 1):gsub('/', '.')
        module = module:gsub('^%.+', ''):gsub('%.+$', '')

        command = string.format('%s -u -m "%s"', py, module)
    elseif filetype == 'cs' then -- cs
        command = string.format('dotnet run --project "%s"', vim.fn.expand '%:p:h')
    elseif filetype == 'lua' then -- lua
        command = string.format('lua "%s"', fullPath)
    elseif filetype == 'r' then -- r
        command = string.format('Rscript "%s"', fullPath)
    elseif filetype == 'rust' then -- rs
        command = 'cargo run'
    elseif filetype == 'sh' then -- bash
        command = fullPath
    elseif filetype == 'nix' then -- nix
        command = string.format('nix-instantiate --eval "%s"', fullPath)
    elseif filetype == 'dart' then -- dart
        command = string.format('dart run %s', fullPath)
    elseif filetype == 'java' then -- java
        command = 'javac -d build src/**/*.java && java -cp build Main'
    elseif filetype == 'go' then -- go
        command = 'go run .'
    else
        vim.cmd.echo '"No runner configured!"'
        return
    end
    -- check if tmux is attached
    -- if it's not then run command in a new terminal
    if vim.fn.system('echo $TMUX'):len() == 1 or vim.g.neovide then
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

local printVar = function()
    local var = vim.fn.getreg 'l'

    local print_formats = {
        python = 'print(f"%s: {%s}")', -- Using f-string for clean output
        lua = 'print("%s:", vim.inspect(%s))', -- vim.inspect handles tables nicely
        javascript = 'console.log("%s:", %s);',
        typescript = 'console.log("%s:", %s);',
        javascriptreact = 'console.log("%s:", %s);',
        typescriptreact = 'console.log("%s:", %s);',
        java = 'System.out.println("%s: " + %s);',
        cs = 'System.Console.WriteLine("%s: " + %s);',
        c = 'printf("%s: %d\\n", %s);', -- Note: %d is just an example, might need adjustment (%s, %p, etc.)
        cpp = 'std::cout << "%s: " << %s << std::endl;',
        go = 'fmt.Printf("%s: %+v\\n", %s)', -- %+v prints fields in structs
        rust = 'println!("%s: {:?}", %s);', -- {:?} uses the Debug trait
        -- Add more languages and their preferred debug print syntax here
        default = 'print("%s: %s")', -- A generic fallback
    }

    local ft = vim.bo.filetype
    local format = print_formats[ft] or print_formats.default
    local print_statement = string.format(format, var, var)

    vim.fn.setreg('l', print_statement)
    vim.cmd 'normal o'
    vim.cmd 'normal "lp'
    vim.cmd.write()
end

return { build = build, contains = contains, map = map, run = run, printVar = printVar }
