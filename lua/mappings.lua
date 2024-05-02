local map = require('util').map

-- escapes
map('i', 'jk', '<Esc>', { desc = 'escape', nowait = true })
map('i', 'jj', '<Esc>', { desc = 'escape', nowait = true })
map('i', '<S-BS>', '<Esc>', { desc = 'escape' })

-- write
map('n', '<leader>cb', ':bdelete <CR>', { desc = '[C]lose [B]uffer' })
map('n', '<leader>cw', '<C-w>q', { desc = '[C]lose [W]indow' })

-- movement
map({ 'n', 'v' }, 'H', 'g0', { desc = 'move to start' })
map({ 'n', 'v' }, 'L', 'g$', { desc = 'move to end' })
map('v', 'J', ":m '>+1<CR>gv=gv", { desc = 'move lines down' })
map('v', 'K', ":m '<-2<CR>gv=gv", { desc = 'move lines up' })

map('n', '<Tab>', ':bnext <CR>', { desc = 'next buffer' })
map('n', '<S-Tab>', ':bprev <CR>', { desc = 'previous buffer' })
map('n', '<C-d>', '<C-d>zz')
map('n', '<C-u>', '<C-u>zz')

-- text
map({ 'n', 'v' }, '<leader>x', '"_x', { desc = 'delete without copy' })
map({ 'n', 'v' }, '<leader>X', '0"_D', { desc = 'delete line without copy' })
map({ 'n', 'v' }, '<leader>p', '"_xP', { desc = 'paste without copy' })
map('v', '<C-k>', "y:'><CR>pgv", { desc = 'copy up' })
map('v', '<C-j>', "y:'<<CR>Pgv", { desc = 'copy down' })

map('n', '<leader>n', '#*viwne', { desc = 'go to next occurence of word' })
map('v', 'n', 'ne', { desc = 'go to next occurence of word' })

map('n', 'yE', "ggyG''zz", { desc = 'yank everything' })
map('n', 'dE', 'ggdG', { desc = 'delete everything' })
map('n', 'cE', 'ggcG', { desc = 'change everything' })
map('n', 'vE', 'gg0vG$', { desc = 'select everything' })

-- window
map('n', '\\', ':vsp <CR>', { desc = 'vertical split' })
map('n', '-', ':sp <CR>', { desc = 'horizontal split' })

-- Keymaps for better default experience
-- See `:help vim.keymap.set()`
map({ 'n', 'v' }, '<Space>', '<Nop>')

-- Remap for dealing with word wrap
map('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true })
map('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true })

-- Diagnostic keymaps
map('n', '[d', vim.diagnostic.goto_prev, { desc = 'go to previous diagnostic message' })
map('n', ']d', vim.diagnostic.goto_next, { desc = 'go to next diagnostic message' })
map('n', '<leader>d', vim.diagnostic.open_float, { desc = 'open floating diagnostic message' })

-- other
map('n', '<C-n>', require('util').run, { desc = 'run current file in new pane' })
map('n', '<C-c>', function()
    require('util').run 'clear'
end, { desc = 'clear' })

map('n', '<leader>fml', '<cmd>CellularAutomaton make_it_rain<CR>', { desc = 'fml' })
map('n', '<leader>e', ':silent !tmux neww -c ~/.config/nvim <CR>', { desc = 'edit config files' })
