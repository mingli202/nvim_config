return {
    'saghen/blink.cmp',
    -- optional: provides snippets for the snippet source
    dependencies = {
        {
            'L3MON4D3/LuaSnip',
            -- follow latest release.
            version = 'v2.*', -- Replace <CurrentMajor> by the latest released major (first number of latest release)
            -- install jsregexp (optional!).
            build = 'make install_jsregexp',
            dependencies = 'rafamadriz/friendly-snippets',
            config = function()
                require('luasnip.loaders.from_vscode').lazy_load()
            end,
        },
    },

    -- use a release tag to download pre-built binaries
    version = '1.*',
    -- AND/OR build from source, requires nightly: https://rust-lang.github.io/rustup/concepts/channels.html#working-with-nightly-rust
    -- build = 'cargo build --release',
    -- If you use nix, you can build from source using latest nightly rust with:
    -- build = 'nix run .#build-plugin',

    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
        -- 'default' (recommended) for mappings similar to built-in completions (C-y to accept)
        -- 'super-tab' for mappings similar to vscode (tab to accept)
        -- 'enter' for enter to accept
        -- 'none' for no mappings
        --
        -- All presets have the following mappings:
        -- C-space: Open menu or open docs if already open
        -- C-n/C-p or Up/Down: Select next/previous item
        -- C-e: Hide menu
        -- C-k: Toggle signature help (if signature.enabled = true)
        --
        -- See :h blink-cmp-config-keymap for defining your own keymap
        keymap = {
            preset = 'default',
            ['<C-e>'] = { 'select_and_accept' },
            ['<C-y>'] = false,
            ['<Tab>'] = false,
            ['<S-Tab>'] = false,
        },

        appearance = {
            -- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
            -- Adjusts spacing to ensure icons are aligned
            nerd_font_variant = 'mono',
        },

        -- (Default) Only show the documentation popup when manually triggered
        completion = {
            documentation = { auto_show = true, auto_show_delay_ms = 0 },
            list = { selection = { preselect = false, auto_insert = true } },
        },

        -- Default list of enabled providers defined so that you can extend it
        -- elsewhere in your config, without redefining it, due to `opts_extend`
        sources = {
            default = { 'lazydev', 'lsp', 'path', 'snippets', 'buffer' },
            providers = {
                lazydev = {
                    name = 'LazyDev',
                    module = 'lazydev.integrations.blink',
                    -- make lazydev completions top priority (see `:h blink.cmp`)
                    score_offset = 100,
                },
            },
        },

        -- (Default) Rust fuzzy matcher for typo resistance and significantly better performance
        -- You may use a lua implementation instead by using `implementation = "lua"` or fallback to the lua implementation,
        -- when the Rust fuzzy matcher is not available, by using `implementation = "prefer_rust"`
        --
        -- See the fuzzy documentation for more information
        fuzzy = { implementation = 'prefer_rust_with_warning' },
        signature = { enabled = true },
        cmdline = {
            keymap = { preset = 'inherit' },
            completion = {
                menu = { auto_show = true },
                list = { selection = { preselect = false, auto_insert = true } },
            },
        },
        snippets = {
            preset = 'luasnip',
        },
    },
    opts_extend = { 'sources.default' },
}
