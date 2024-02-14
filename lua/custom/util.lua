-- [[ Configure LSP ]]
--  This function gets run when an LSP connects to a particular buffer.
-- NOTE: Remember that lua is a real programming language, and as such it is possible
-- to define small helper and utility functions so you don't have to repeat yourself
-- many times.
-- In this case, we create a function that lets us more easily define mappings specific
-- for LSP related items. It sets the mode, buffer and description for us each time.
local on_attach = function(_, bufnr)
    local nmap = function(keys, func, desc)
        if desc then
            desc = 'LSP: ' .. desc
        end

        vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
    end

    nmap('<leader>lr', vim.lsp.buf.rename, '[L]sp [R]ename')
    nmap('<leader>la', vim.lsp.buf.code_action, '[L]sp code [A]ction')
    nmap('<leader>lR', ':LspRestart <CR>', '[L]sp [R]estart')

    nmap('gd', vim.lsp.buf.definition, '[G]oto [D]efinition')
    nmap('gr', vim.lsp.buf.references, '[G]oto [R]eferences')
    nmap('gi', vim.lsp.buf.implementation, '[G]oto [I]mplementation')
    nmap('<leader>D', require('telescope.builtin').lsp_type_definitions, 'Type [D]efinition')
    nmap('<leader>ls', require('telescope.builtin').lsp_document_symbols, '[L]sp Document [S]ymbols')
    nmap('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

    nmap('<leader>fr', require('telescope.builtin').lsp_references, '[F]ind [R]eferences')
    nmap('<leader>fi', require('telescope.builtin').lsp_implementations, '[F]ind [I]mplementations')

    -- See `:help K` for why this keymap
    nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
    nmap('˚', vim.lsp.buf.signature_help, 'Signature Documentation')

    -- Lesser used LSP functionality
    nmap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
    nmap('<leader>wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder')
    nmap('<leader>wr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove Folder')
    nmap('<leader>wl', function()
        print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, '[W]orkspace [L]ist Folders')
end

-- for c and cpp
local build = function()
    local filetype = vim.bo.ft
    local fullPath = vim.fn.expand '%:p'
    local fnameWithoutExtension = vim.fn.expand('%:t'):gsub('.' .. filetype, '')
    local directory = vim.fn.expand '%:p:h'
    local binary = directory .. '/bin/' .. fnameWithoutExtension

    if filetype == 'cpp' then
        vim.cmd(
            '!mkdir -p "'
                .. directory:gsub('[%%%#]', '\\%1')
                .. '/bin" && clang++ -std=c++2b "'
                .. fullPath:gsub('[%%%#]', '\\%1')
                .. '" -o "'
                .. binary:gsub('[%%%#]', '\\%1')
                .. '" -g'
        )
    elseif filetype == 'c' then
        vim.cmd(
            '!mkdir -p "'
                .. directory:gsub('[%%%#]', '\\%1')
                .. '/bin" && clang -std=c2x "'
                .. fullPath:gsub('[%%%#]', '\\%1')
                .. '" -o "'
                .. binary:gsub('[%%%#]', '\\%1')
                .. '" -g'
        )
    else
        vim.notify 'Wrong filetype'
    end
end

return { on_attach = on_attach, build = build }
