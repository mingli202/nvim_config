return {
    settings = {
        Lua = {
            runtime = {
                -- Tell the language server which version of Lua you're using
                -- (most likely LuaJIT in the case of Neovim)
                version = 'LuaJIT',
            },
            -- Make the server aware of Neovim runtime files
            workspace = {
                checkThirdParty = false,
                library = {
                    vim.env.VIMRUNTIME,
                    -- Depending on the usage, you might want to add additional paths here.
                    -- "${3rd}/luv/library"
                    -- "${3rd}/busted/library",
                },
                -- or pull in all of 'runtimepath'. this is a lot slower
                -- library = vim.api.nvim_get_runtime_file("", true)
            },
        },
    },
}
