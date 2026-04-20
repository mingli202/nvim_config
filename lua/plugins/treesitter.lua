return {
    { -- Highlight, edit, and navigate code
        'nvim-treesitter/nvim-treesitter',
        build = ':TSUpdate',
        dependencies = {
            { 'nvim-treesitter/nvim-treesitter-context', opts = { max_lines = 5 } },
        },
        lazy = false,
        config = function()
            -- ensure basic parser are installed
            local parsers = { 'bash', 'c', 'diff', 'html', 'lua', 'luadoc', 'markdown', 'markdown_inline', 'query', 'vim', 'vimdoc' }
            require('nvim-treesitter').install(parsers)

            ---@param buf integer
            ---@param language string
            local function treesitter_try_attach(buf, language)
                -- check if parser exists and load it
                if not vim.treesitter.language.add(language) then
                    return
                end
                -- enables syntax highlighting and other treesitter features
                vim.treesitter.start(buf, language)

                -- enables treesitter based folds
                -- for more info on folds see `:help folds`
                -- vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
                -- vim.wo.foldmethod = 'expr'

                -- check if treesitter indentation is available for this language, and if so enable it
                -- in case there is no indent query, the indentexpr will fallback to the vim's built in one
                local has_indent_query = vim.treesitter.query.get(language, 'indents') ~= nil

                -- enables treesitter based indentation
                if has_indent_query then
                    vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
                end
            end

            local available_parsers = require('nvim-treesitter').get_available()
            vim.api.nvim_create_autocmd('FileType', {
                callback = function(args)
                    local buf, filetype = args.buf, args.match

                    local language = vim.treesitter.language.get_lang(filetype)
                    if not language then
                        return
                    end

                    local installed_parsers = require('nvim-treesitter').get_installed 'parsers'

                    if vim.tbl_contains(installed_parsers, language) then
                        -- enable the parser if it is installed
                        treesitter_try_attach(buf, language)
                    elseif vim.tbl_contains(available_parsers, language) then
                        -- if a parser is available in `nvim-treesitter` auto install it, and enable it after the installation is done
                        require('nvim-treesitter').install(language):await(function()
                            treesitter_try_attach(buf, language)
                        end)
                    else
                        -- try to enable treesitter features in case the parser exists but is not available from `nvim-treesitter`
                        treesitter_try_attach(buf, language)
                    end
                end,
            })
        end,
    },
    {
        'nvim-treesitter/nvim-treesitter-textobjects',
        branch = 'main',
        init = function()
            -- Disable entire built-in ftplugin mappings to avoid conflicts.
            -- See https://github.com/neovim/neovim/tree/master/runtime/ftplugin for built-in ftplugins.
            vim.g.no_plugin_maps = true

            -- Or, disable per filetype (add as you like)
            -- vim.g.no_python_maps = true
            -- vim.g.no_ruby_maps = true
            -- vim.g.no_rust_maps = true
            -- vim.g.no_go_maps = true
        end,
        config = function()
            -- put your config here
            local map = require('util').map
            map('n', '<leader>a', function()
                require('nvim-treesitter-textobjects.swap').swap_next '@parameter.inner'
            end)

            map('n', '<leader>A', function()
                require('nvim-treesitter-textobjects.swap').swap_previous '@parameter.inner'
            end)
        end,
    },
}
