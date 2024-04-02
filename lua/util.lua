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

-- [[ Configure LSP ]]
--  This function gets run when an LSP connects to a particular buffer.
-- NOTE: Remember that lua is a real programming language, and as such it is possible
-- to define small helper and utility functions so you don't have to repeat yourself
-- many times.
-- In this case, we create a function that lets us more easily define mappings specific
-- for LSP related items. It sets the mode, buffer and description for us each time.
local formatters = {
    ['null-ls'] = true,
    r_language_server = true,
}

local trouble = require 'trouble'
local telescope = require 'telescope.builtin'

local on_attach = function(args)
    local nmap = function(keys, func, desc)
        if desc then
            desc = 'LSP: ' .. desc
        end

        vim.keymap.set('n', keys, func, { buffer = args.buf, desc = desc })
    end

    nmap('<leader>lr', vim.lsp.buf.rename, '[L]sp [R]ename')
    nmap('<leader>la', vim.lsp.buf.code_action, '[L]sp code [A]ction')
    nmap('<leader>lR', ':LspRestart <CR>', '[L]sp [R]estart')

    nmap('gd', function()
        telescope.lsp_definitions()
    end, '[G]oto [D]efinition')
    nmap('gr', function()
        trouble.toggle 'lsp_references'
    end, '[G]oto [R]eferences')

    nmap('gI', vim.lsp.buf.implementation, '[G]oto [I]mplementation')
    nmap('<leader>D', telescope.lsp_type_definitions, 'Type [D]efinition')
    nmap('<leader>ls', telescope.lsp_document_symbols, '[L]sp Document [S]ymbols')
    nmap('<leader>ws', telescope.lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

    nmap('<leader>fr', telescope.lsp_references, '[F]ind [R]eferences')
    nmap('<leader>fi', telescope.lsp_implementations, '[F]ind [I]mplementations')

    -- See `:help K` for why this keymap
    nmap('K', vim.lsp.buf.hover, 'Hover Documentation')

    -- Lesser used LSP functionality
    nmap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
    nmap('<leader>wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder')
    nmap('<leader>wr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove Folder')
    nmap('<leader>wl', function()
        print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, '[W]orkspace [L]ist Folders')

    -- autoformat for null-ls
    -- all my formatters come from null_ls
    -- so make null_ls the primary source of formatting
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if client.supports_method 'textDocument/formatting' then
        local aug = vim.api.nvim_create_augroup('LspFormatting', { clear = true })
        vim.api.nvim_create_autocmd('BufWritePre', {
            group = aug,
            callback = function()
                vim.lsp.buf.format {
                    -- format only from null_ls or any other exceptions
                    filter = function(cl)
                        return formatters[cl.name]
                    end,
                    buffer = args.buf, -- format current buffer
                }
            end,
        })
    end

    -- -- have to check if eslint_d and prettierd are running
    -- -- because they are separate binaries that have to be shut down manually
    -- -- they will run when the filetype matches their configured filetypes
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
        'json',
        'jsonc',
        'yaml',
        'markdown',
        'markdown.mdx',
        'graphql',
        'handlebars',
    }

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

-- nvim-cmp supports additional completion capabilities, so broadcast that to servers
local defaultCapabilities = vim.lsp.protocol.make_client_capabilities()
local capabilities = require('cmp_nvim_lsp').default_capabilities(defaultCapabilities)
capabilities.textDocument.foldingRange = {
    dynamicRegistration = false,
    lineFoldingOnly = true,
}

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
local run = function(make)
    local filetype = vim.bo.ft
    local fullPath = vim.fn.expand '%:p'
    local command = ''

    if make then
        command = 'make'
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

return { on_attach = on_attach, build = build, contains = contains, capabilities = capabilities, map = map, run = run }
