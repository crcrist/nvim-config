
-- Set up leader key (Space)
vim.g.mapleader = " "

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "git@github.com:folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Basic settings
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.wrap = false
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.termguicolors = true

-- Plugin specifications
require("lazy").setup({
  -- Color scheme
  {
    "sainnhe/everforest",
    priority = 1000,
    config = function()
      vim.g.everforest_background = 'soft'
      vim.g.everforest_better_performance = 1
      vim.cmd([[colorscheme everforest]])
    end,
  },

  -- ToggleTerm
  {
    "akinsho/toggleterm.nvim",
    config = function()
      require("toggleterm").setup({
        size = 20,
        open_mapping = [[<C-t>]],
        direction = "horizontal",
        shade_terminals = true,
      })
    end,
  },
  


  -- Web devicons
  {
    "nvim-tree/nvim-web-devicons",
    config = function()
      require('nvim-web-devicons').setup({
        default = true,
      })
    end,
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
            folder_closed = "",
            folder_open = "",
            folder_empty = "",
          },
        },
      })
    end,
  },

  -- Telescope
  {
    "nvim-telescope/telescope.nvim",
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
          file_ignore_patterns = { "node_modules", ".git/", "dist", "package-lock.json" },
          mappings = {
            i = {
              ["<C-k>"] = actions.move_selection_previous,
              ["<C-j>"] = actions.move_selection_next,
            },
          },
        },
      })
      
      telescope.load_extension('fzf')
      
      local builtin = require('telescope.builtin')
      vim.keymap.set('n', '<leader>p', builtin.find_files, { desc = 'Find files' })
      vim.keymap.set('n', '<leader>ps', builtin.live_grep, { desc = 'Live grep' })
      vim.keymap.set('n', '<leader>pb', builtin.buffers, { desc = 'Find buffers' })
      vim.keymap.set('n', '<leader>ph', builtin.help_tags, { desc = 'Help tags' })
    end,
  },

  -- Treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    dependencies = { "nvim-treesitter/nvim-treesitter-textobjects" },
    config = function()
      require('nvim-treesitter.configs').setup({
        ensure_installed = { "rust", "lua", "python", "bash", "json" },
        highlight = {
          enable = true,
        },
        indent = {
          enable = true,
        },
      })
    end,
  },

  -- LSP and Autocompletion
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
    },
  },
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

-- Transparency fix
vim.cmd([[highlight Normal guibg=NONE ctermbg=NONE]])
vim.cmd([[highlight NormalFloat guibg=NONE ctermbg=NONE]])

-- Mason and LSP configuration
require("mason").setup()
require("mason-lspconfig").setup({
  ensure_installed = { "rust_analyzer", "pyright", "lua_ls", "tsserver" },
})

-- Python LSP setup
require('lspconfig').pyright.setup{
  capabilities = require('cmp_nvim_lsp').default_capabilities(),
  on_attach = function(client, bufnr)
    -- Your on_attach function if you have one
  end
}

require("lspconfig").rust_analyzer.setup({
  settings = {
    ["rust-analyzer"] = {
      checkOnSave = {
        command = "clippy",
      },
      diagnostics = {
        enable = true,
      },
    },
  },
})

-- LSP diagnostics workaround
for _, method in ipairs({ 'textDocument/diagnostic', 'workspace/diagnostic' }) do
  local default_diagnostic_handler = vim.lsp.handlers[method]
  if default_diagnostic_handler then
    vim.lsp.handlers[method] = function(err, result, context, config)
      if err and err.code == -32802 then
        return -- Ignore specific error code -32802
      end
      return default_diagnostic_handler(err, result, context, config)
    end
  end
end

-- Keymaps
vim.keymap.set('n', 'gD', vim.lsp.buf.declaration)
vim.keymap.set('n', 'gd', vim.lsp.buf.definition)
vim.keymap.set('n', 'K', vim.lsp.buf.hover)
vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action)
vim.keymap.set('n', '<leader>f', vim.lsp.buf.format)
vim.keymap.set('n', '<leader>e', function()
  vim.cmd('Neotree toggle')
end)

