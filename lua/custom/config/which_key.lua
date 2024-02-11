require('which-key').setup {}

-- document existing key chains
require('which-key').register {
    ['<leader>c'] = { name = '[C]lose', _ = 'which_key_ignore' },
    ['<leader>d'] = { name = '[D]iagnostics', _ = 'which_key_ignore' },
    ['<leader>g'] = { name = '[G]it', _ = 'which_key_ignore' },
    ['<leader>r'] = { name = '[R]ename', _ = 'which_key_ignore' },
    ['<leader>t'] = { name = '[T]oggle', _ = 'which_key_ignore' },
    ['<leader>w'] = { name = '[W]orkspace', _ = 'which_key_ignore' },
    ['<leader>l'] = { name = '[L]sp', _ = 'which_key_ignore' },
    ['<leader>f'] = { name = '[F]ind', _ = 'which_key_ignore' },
    ['<leader>h'] = { name = '[H]arpoon', _ = 'which_key_ignore' },
    ['<leader>m'] = { name = '[M]arks', _ = 'which_key_ignore' },
}
-- register which-key VISUAL mode
-- required for visual <leader>hs (hunk stage) to work
require('which-key').register({
    ['<leader>'] = { name = 'VISUAL <leader>' },
    ['<leader>gh'] = { 'Git [H]unk' },
}, { mode = 'v' })
