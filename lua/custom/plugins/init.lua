-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information
return {
  { 'nvim-tree/nvim-web-devicons', opts = {} },
  -- NOTE: First, some plugins that don't require any configuration

  -- Git related plugins
  'tpope/vim-fugitive',
  'tpope/vim-rhubarb',

  -- Detect tabstop and shiftwidth automatically
  'tpope/vim-sleuth',

  -- Useful plugin to show you pending keybinds.
  {
    'folke/which-key.nvim',
    config = function()
      require 'custom.config.which_key'
    end,
  },

  {
    -- Set lualine as statusline
    'nvim-lualine/lualine.nvim',
    -- See `:help lualine.txt`
    config = function()
      require 'custom.config.lualine'
    end,
  },

  -- "gc" to comment visual regions/lines
  { 'numToStr/Comment.nvim', opts = {} },

  {
    -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    dependencies = {
      'nvim-treesitter/nvim-treesitter-textobjects',
    },
    build = ':TSUpdate',
    config = function()
      require 'custom.config.treesitter'
    end,
  },

  {
    -- Autocompletion
    'hrsh7th/nvim-cmp',
    dependencies = {
      -- Snippet Engine & its associated nvim-cmp source
      'L3MON4D3/LuaSnip',
      'saadparwaiz1/cmp_luasnip',

      -- Adds LSP completion capabilities
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-path',

      -- Adds a number of user-friendly snippets
      'rafamadriz/friendly-snippets',
    },
    config = function()
      require 'custom.config.cmp'
    end,
  },

  {
    'windwp/nvim-autopairs',
    event = 'InsertEnter',
    opts = {}, -- this is equvalent to setup({}) function
  },

  {
    'roobert/tailwindcss-colorizer-cmp.nvim',
    -- optionally, override the default options:
    config = function()
      require('tailwindcss-colorizer-cmp').setup {
        color_square_width = 2,
      }
    end,
  },

  {
    'NvChad/nvim-colorizer.lua',
    opts = {
      filetypes = {
        '*',
        '!markdown', -- disable for markdown
      },
      user_default_options = {
        tailwind = true,
      },
    },
  },

  {
    'chentoast/marks.nvim',
    config = function()
      require('marks').setup {
        mappings = {
          next = ']m', --custom mappings
          previous = '[m',
        },
      }
    end,
  },

  {
    'lukas-reineke/indent-blankline.nvim',
    main = 'ibl',
    opts = {},
  },
}
