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

-- escapes
map('i', 'jk', '<Esc>', { desc = 'escape' })
map('i', 'jj', '<Esc>', { desc = 'escape' })
map('i', '<S-BS>', '<Esc>', { desc = 'escape' })

-- write
map('n', '<leader>w', ':w <CR>', { desc = 'write' })
map('n', '<leader>cb', ':bdelete <CR>', { desc = '[C]lose [B]uffer' })
map('n', '<leader>cw', '<C-w>q', { desc = '[C]lose [W]indow' })

-- movement
map({ 'n', 'v' }, 'H', '_', { desc = 'move to start' })
map({ 'n', 'v' }, 'L', '$', { desc = 'move to end' })
map('v', 'J', ":m '>+1<CR>gv=gv", { desc = 'move lines down' })
map('v', 'K', ":m '<-2<CR>gv=gv", { desc = 'move lines up' })

map('n', '<Tab>', ':bnext <CR>', { desc = 'next buffer' })
map('n', '<S-Tab>', ':bprev <CR>', { desc = 'previous buffer' })

-- text
map({ 'n', 'v' }, '<leader>x', '"_x', { desc = 'delete' })
map({ 'n', 'v' }, '<leader>X', '0"_D', { desc = 'delete line' })
map('v', '<C-k>', "y:'><CR>pgv", { desc = 'copy up' })
map('v', '<C-j>', "y:'<<CR>Pgv", { desc = 'copy down' })

map('n', '<leader>n', '/<C-r>*<CR>@n', { desc = 'execute macro on last yanked word' })

-- window
map('n', '|', ':vsp <CR>', { desc = 'vertical split' })
map('n', '\\', ':sp <CR>', { desc = 'horizontal split' })
map('n', '<C-h>', '<C-w>h', { desc = 'window left' })
map('n', '<C-j>', '<C-w>j', { desc = 'window down' })
map('n', '<C-k>', '<C-w>k', { desc = 'window up' })
map('n', '<C-l>', '<C-w>l', { desc = 'window right' })

-- Keymaps for better default experience
-- See `:help vim.keymap.set()`
map({ 'n', 'v' }, '<Space>', '<Nop>')

-- Remap for dealing with word wrap
map('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true })
map('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true })

-- Diagnostic keymaps
map('n', '[d', vim.diagnostic.goto_prev, { desc = 'go to previous diagnostic message' })
map('n', ']d', vim.diagnostic.goto_next, { desc = 'go to next diagnostic message' })
map('n', '∂', vim.diagnostic.open_float, { desc = 'open floating diagnostic message' })
map('n', 'Î', vim.diagnostic.setloclist, { desc = 'open diagnostics list' })

-- marks
local marks = require 'marks'
map('n', '<leader>ml', vim.cmd.marks, { desc = '[M]arks [L]ist' })
map('n', '<leader>md', marks.delete_line, { desc = '[M]ark [D]elete' })
map('n', '<leader>mc', marks.delete_buf, { desc = '[M]arks [C]ear' })
map('n', '[m', marks.prev, { desc = 'previous mark' })
map('n', ']m', marks.next, { desc = 'next mark' })

-- harpoon
map('n', '<leader>ht', require('harpoon.mark').toggle_file, { desc = '[H]arpoon [T]oogle' })
map('n', '<leader>hc', require('harpoon.mark').clear_all, { desc = '[H]arpoon [C]lear all' })
map('n', '<leader>fh', ':Telescope harpoon marks <CR>', { desc = '[F]ind [H]arpoon' })
map('n', '<leader>hl', require('harpoon.ui').toggle_quick_menu, { desc = '[H]arpoon [L]ist' })
map('n', '[h', require('harpoon.ui').nav_prev, { desc = 'previous harpoon' })
map('n', ']h', require('harpoon.ui').nav_next, { desc = 'next harpoon' })
map('n', '<leader>hn', function()
  local char = vim.fn.getchar() - 48
  require('harpoon.ui').nav_file(char)
end, { desc = '[H]arpoon [N]av' })

-- neotree
map('n', '<leader>o', ':Neotree position=current reveal=true <CR>', { desc = '[O]pen explorer window' })
map('n', '<leader>e', ':Neotree reveal=true <CR>', { desc = 'Explorer to side' })
map('n', '<leader>ce', ':Neotree close <CR>', { desc = '[C]lose [E]xplorer' })

-- undotree
map('n', '<leader>u', ':UndotreeToggle <CR>', { desc = '[U]ndo tree' })

-- debugger
local dap = require 'dap'

map('n', '<F4>', dap.restart, { desc = 'debug: restart adapter' })
map('n', '<F5>', dap.continue, { desc = 'debug: start/continue' })
map('n', '<F6>', dap.terminate, { desc = 'debug: terminate' })

map('n', '<Right>', dap.step_over, { desc = 'debug: step over' })
map('n', '<Down>', dap.step_into, { desc = 'debug: step into' })
map('n', '<Up>', dap.step_out, { desc = 'debug: step out' })
map('n', '<leader>b', dap.toggle_breakpoint, { desc = 'toggle [B]reakpoint' })
map('n', '<leader>dr', dap.repl.open, { desc = 'debug: open [r]epl' })
map('n', '<leader>dl', dap.run_last, { desc = 'debug: run last' })

map({ 'n', 'v' }, '<Leader>dh', require('dap.ui.widgets').hover, { desc = 'debug: hover widgets' })
map({ 'n', 'v' }, '<Leader>dp', require('dap.ui.widgets').preview, { desc = 'debug: preview widgets' })
map('n', '<Leader>df', function()
  local widgets = require 'dap.ui.widgets'
  widgets.centered_float(widgets.frames)
end, { desc = 'debug: widget frames' })
map('n', '<Leader>ds', function()
  local widgets = require 'dap.ui.widgets'
  widgets.centered_float(widgets.scopes)
end, { desc = 'debug: widget scope' })

-- other
map('n', '<C-S-n>', ':RunCurrentFile <CR>', { desc = 'Run current file' })
