-- Set <space> as the leader key
-- See `:help mapleader`
-- Must happen before plugins are required (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

vim.loader.enable()

-- [[ Install `lazy.nvim` plugin manager ]]
--    https://github.com/folke/lazy.nvim
--    `:help lazy.nvim.txt` for more info
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
    vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
end
vim.opt.rtp:prepend(lazypath)

require('lazy').setup {
    spec = {
        { import = 'plugins' },
    },
    change_detection = {
        -- automatically check for config file changes and reload the ui
        enabled = true,
        notify = false, -- disable notification when changes are found
    },
}

-- catppuccin, ondark, tokyonight
-- vim.cmd.colorscheme 'onedark'
-- vim.cmd.colorscheme 'catppuccin'
vim.cmd.colorscheme 'tokyonight'

vim.opt.tabstop = 4 -- tab width 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.autoindent = true
vim.opt.signcolumn = 'yes'

vim.opt.wrap = true
vim.wo.linebreak = true

vim.opt.swapfile = false

-- Set highlight on search
vim.opt.hlsearch = false

-- Make line numbers default
vim.wo.number = true
vim.wo.relativenumber = true
vim.api.nvim_set_hl(0, 'LineNr', { fg = 'white' }) -- make it brigther cuz i can't see shit
vim.api.nvim_set_hl(0, 'LineNrAbove', { fg = '#999999' })
vim.api.nvim_set_hl(0, 'LineNrBelow', { fg = '#999999' })

-- Enable mouse mode
vim.opt.mouse = 'a'

-- Sync clipboard between OS and Neovim.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
vim.opt.clipboard = 'unnamedplus'

-- Enable break indent
vim.opt.breakindent = true

-- Save undo history
vim.opt.undofile = true

-- Case-insensitive searching UNLESS \C or capital in search
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Keep signcolumn on by default
vim.opt.signcolumn = 'yes'

-- Decrease update time
vim.opt.updatetime = 250
vim.opt.timeoutlen = 300

-- Set completeopt to have a better completion experience
vim.opt.completeopt = { 'menu', 'menuone', 'noselect' }

-- Make sure your terminal supports this
vim.opt.termguicolors = true

-- for folding stuff
vim.opt.foldcolumn = '0'
vim.opt.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
vim.opt.foldlevelstart = 99
vim.opt.foldenable = true

vim.opt.scrolloff = 6 -- how much lines to keep above/below cursor
vim.opt.showmode = false
vim.opt.cursorline = true -- ui that show the cursor line

require 'mappings'
