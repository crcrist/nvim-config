
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
  -- Color scheme with proper setup
  {
    "Abstract-IDE/Abstract-cs",
    name = "abstract-cs",
    priority = 1000,
    config = function()
      -- Set up the colorscheme here
      vim.cmd[[colorscheme abscs]]
    end
  },
  
  -- Web devicons
  {
    "nvim-tree/nvim-web-devicons",
    config = function()
      require('nvim-web-devicons').setup({
        override = {
          lua = {
            icon = "",
            color = "#51a0cf",
            name = "Lua"
          },
        },
        default = true,
      })
    end
  },

  -- File tree
  {
    "nvim-neo-tree/neo-tree.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    },
    config = function()
      require("neo-tree").setup({
        default_component_configs = {
          icon = {
            folder_closed = "",
            folder_open = "",
            folder_empty = "󰜌",
          },
          git_status = {
            symbols = {
              added = "",
              modified = "",
              deleted = "✖",
              renamed = "",
              untracked = "",
              ignored = "",
              unstaged = "",
              staged = "",
              conflict = "",
            }
          },
        }
      })
    end,
  },

  {
    'nvim-telescope/telescope.nvim',
    branch = '0.1.x', 
    dependencies = { 
      'nvim-lua/plenary.nvim',
      {
        'nvim-telescope/telescope-fzf-native.nvim',
        build = 'make'
      }
    },
    config = function()
      local telescope = require('telescope')
      local actions = require('telescope.actions')
      
      telescope.setup({
        defaults = {
          file_ignore_patterns = { "node_modules", ".git/" },
          mappings = {
            i = {
              ["<C-k>"] = actions.move_selection_previous,
              ["<C-j>"] = actions.move_selection_next,
            }
          }
        }
      })
      
      telescope.load_extension('fzf')
      
      local builtin = require('telescope.builtin')
      vim.keymap.set('n', '<leader>p', builtin.find_files, { desc = 'Find files' })
      vim.keymap.set('n', '<leader>ps', builtin.live_grep, { desc = 'Live grep' })
      vim.keymap.set('n', '<leader>pb', builtin.buffers, { desc = 'Find buffers' })
      vim.keymap.set('n', '<leader>ph', builtin.help_tags, { desc = 'Help tags' })
    end
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

-- LSP Configuration
require("mason").setup()
require("mason-lspconfig").setup({
  ensure_installed = { "rust_analyzer" }
})

-- Workaround for LSP diagnostic errors (e.g., code -32802)
for _, method in ipairs({ 'textDocument/diagnostic', 'workspace/diagnostic' }) do
  local default_diagnostic_handler = vim.lsp.handlers[method]
  vim.lsp.handlers[method] = function(err, result, context, config)
    if err ~= nil and err.code == -32802 then
      return -- Ignore specific error code -32802
    end
    return default_diagnostic_handler(err, result, context, config)
  end
end

-- Configure rust-analyzer
require("lspconfig").rust_analyzer.setup({
  settings = {
    ["rust-analyzer"] = {
      checkOnSave = {
        command = "clippy",
      },
      diagnostics = {
        enable = true,
      },
    }
  }
})

-- LSP keybindings
vim.keymap.set('n', 'gD', vim.lsp.buf.declaration)
vim.keymap.set('n', 'gd', vim.lsp.buf.definition)
vim.keymap.set('n', 'K', vim.lsp.buf.hover)
vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action)
vim.keymap.set('n', '<leader>f', vim.lsp.buf.format)

-- Treesitter configuration
require('nvim-treesitter.configs').setup({
  ensure_installed = { "rust" },
  highlight = {
    enable = true,
  },
  indent = {
    enable = true,
  },
})

-- Keymaps (fixed the syntax)
vim.keymap.set('n', '<leader>e', function()
  vim.cmd('Neotree toggle')
end)

