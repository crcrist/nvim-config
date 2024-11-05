-- Set up leader key (Space)
vim.g.mapleader = " "

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Basic settings
vim.opt.number = true         -- Line numbers
vim.opt.relativenumber = true -- Relative line numbers
vim.opt.shiftwidth = 2        -- Size of indent
vim.opt.tabstop = 2          -- Size of tab
vim.opt.expandtab = true     -- Use spaces instead of tabs
vim.opt.smartindent = true   -- Auto indent
vim.opt.wrap = false         -- No line wrap
vim.opt.ignorecase = true    -- Ignore case in search
vim.opt.smartcase = true     -- Unless uppercase is used
vim.opt.termguicolors = true -- True color support

-- Plugin specifications
require("lazy").setup({
  -- Color scheme
  { "folke/tokyonight.nvim", priority = 1000 },
  
  -- File tree
  {
    "nvim-neo-tree/neo-tree.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    },
  },

  -- Treesitter for better syntax highlighting
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
  },

  -- LSP Support
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
    },
  },

  -- Autocompletion
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
      "rafamadriz/friendly-snippets",
    },
  },
})

-- Color scheme setup
vim.schedule(function()
    vim.cmd[[colorscheme tokyonight]]
end)
-- Keymaps
vim.keymap.set('n', '<leader>e', ':Neotree toggle<CR>')  -- Toggle file tree
