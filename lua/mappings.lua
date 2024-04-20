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

map('n', '[t', ':tabprevious <CR>', { desc = 'previous tab' })
map('n', ']t', ':tabnext <CR>', { desc = 'next tab' })
map('n', '<leader>ct', ':tabclose <CR>', { desc = '[C]lose [T]ab' })

-- text
map({ 'n', 'v' }, '<leader>x', '"_x', { desc = 'delete' })
map({ 'n', 'v' }, '<leader>X', '0"_D', { desc = 'delete line' })
map({ 'n', 'v' }, '<leader>p', '"_xP', { desc = 'paste' })
map('v', '<C-k>', "y:'><CR>pgv", { desc = 'copy up' })
map('v', '<C-j>', "y:'<<CR>Pgv", { desc = 'copy down' })

map('n', '<leader>n', '#*viwne', { desc = 'go to next occurence of word' })
map('v', '<leader>n', 'ne', { desc = 'go to next occurence of word' })
map('n', 'yie', "ggyG''zz", { desc = 'yank everything' })
map('n', 'die', 'ggdG', { desc = 'delete everything' })

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

-- marks
local marks = require 'marks'
map('n', '<leader>ml', vim.cmd.marks, { desc = '[M]arks [L]ist' })
map('n', '<leader>md', marks.delete_line, { desc = '[M]ark [D]elete' })
map('n', '<leader>mc', function()
    marks.delete_buf()
    vim.cmd 'wshada!'
end, { desc = '[M]arks [C]ear' })

-- harpoon
map('n', '<leader>ht', require('harpoon.mark').toggle_file, { desc = '[H]arpoon [T]oogle' })
map('n', '<leader>hc', require('harpoon.mark').clear_all, { desc = '[H]arpoon [C]lear all' })
map('n', '<leader>fh', ':Telescope harpoon marks <CR>', { desc = '[F]ind [H]arpoon' })
map('n', '<leader>hl', require('harpoon.ui').toggle_quick_menu, { desc = '[H]arpoon [L]ist' })
map('n', '[h', require('harpoon.ui').nav_prev, { desc = 'previous harpoon' })
map('n', ']h', require('harpoon.ui').nav_next, { desc = 'next harpoon' })
map('n', '<leader>h', function()
    local char = vim.fn.getchar() - 48
    require('harpoon.ui').nav_file(char)
end, { desc = '[H]arpoon [N]av' })

-- neotree
map('n', '<leader>o', ':Neotree position=current reveal=true <CR>', { desc = '[O]pen explorer window' })
map('n', '<leader>e', ':Neotree reveal=true position=right <CR>', { desc = 'Explorer to side' })
map('n', '<leader>ce', ':Neotree close <CR>', { desc = '[C]lose [E]xplorer' })

-- undotree
map('n', '<leader>u', ':UndotreeToggle <CR>', { desc = '[U]ndo tree' })

-- debugger
local dap = require 'dap'

map('n', '<F4>', dap.restart, { desc = 'debug: restart adapter' })
map('n', '<F5>', dap.continue, { desc = 'debug: start/continue' })
map('n', '<F6>', dap.terminate, { desc = 'debug: terminate' })
map('n', '<leader>b', dap.toggle_breakpoint, { desc = 'toggle [B]reakpoint' })

-- ufo
local ufo = require 'ufo'

map('n', 'zR', ufo.openAllFolds, { desc = 'folds: open all' })
map('n', 'zM', ufo.closeAllFolds, { desc = 'folds: close all' })

-- trouble
local trouble = require 'trouble'
map('n', '<leader>tt', trouble.toggle, { desc = '[T]oggle [T]rouble' })
map('n', '<leader>tl', function()
    trouble.toggle 'loclist'
end, { desc = '[T]rouble [L]ocation list' })
map('n', '<leader>tq', function()
    trouble.toggle 'quickfix'
end, { desc = '[T]rouble [Q]uickfix list' })

map('n', '<leader>td', function()
    trouble.toggle 'document_diagnostics'
end, { desc = '[T]rouble [D]ocument diagnostics' })
map('n', '<leader>tw', function()
    trouble.toggle 'document_diagnostics'
end, {
    desc = '[T]rouble [W]orkspace diagnostics',
})

-- treesj
local treesj = require 'treesj'
map('n', 'gs', treesj.toggle, { desc = 'treesj toggle' })

-- other
map('n', '<C-n>', require('util').run, { desc = 'run current file in new pane' })
map('n', '<C-c>', function()
    require('util').run 'clear'
end, { desc = 'stop' })
