return {
    settings = {
        ['rust-analyzer'] = {
            diagnostics = {
                styleLints = {
                    enable = true,
                },
            },
            check = {
                command = 'clippy',
            },
            imports = {
                granularity = {
                    group = 'module',
                },
                prefix = 'self',
            },
            cargo = {
                buildScripts = {
                    enable = true,
                },
            },
            procMacro = {
                enable = true,
            },
        },
    },
}
