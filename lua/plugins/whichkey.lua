-- Useful plugin to show you pending keybinds.
return {
    'folke/which-key.nvim',
    config = function()
        require('which-key').setup {}

        -- document existing key chains
        require('which-key').add {
            { '<leader>c', group = '[C]lose' },
            { '<leader>c_', hidden = true },
            { '<leader>d', group = '[D]iagnostics' },
            { '<leader>d_', hidden = true },
            { '<leader>f', group = '[F]ind' },
            { '<leader>f_', hidden = true },
            { '<leader>g', group = '[G]it' },
            { '<leader>g_', hidden = true },
            { '<leader>h', group = '[H]arpoon' },
            { '<leader>h_', hidden = true },
            { '<leader>l', group = '[L]sp' },
            { '<leader>l_', hidden = true },
            { '<leader>m', group = '[M]arks' },
            { '<leader>m_', hidden = true },
            { '<leader>t', group = '[T]rouble' },
            { '<leader>t_', hidden = true },
            { '<leader>w', group = '[W]orkspace' },
            { '<leader>w_', hidden = true },

            { '<leader>', group = 'VISUAL <leader>', mode = 'v' },
            { '<leader>gh', desc = 'Git [H]unk', mode = 'v' },
        }
    end,
}
