
-- Set leader key
vim.g.mapleader = " "

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
vim.opt.mouse = "a"

-- Enable file type detection and plugins
vim.cmd("filetype plugin indent on")

-- Basic keymaps
vim.keymap.set("n", "<leader>w", ":w<CR>", { silent = true }) -- Save
vim.keymap.set("n", "<leader>q", ":q<CR>", { silent = true }) -- Quit

-- Lazy.nvim setup
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({ "git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  -- File tree
  { "nvim-tree/nvim-tree.lua", dependencies = { "nvim-tree/nvim-web-devicons" }, config = function()
      require("nvim-tree").setup({})
      vim.keymap.set("n", "<leader>e", ":NvimTreeToggle<CR>", { silent = true, noremap = true })
    end,
  },

  -- Integrated terminal
  { "akinsho/toggleterm.nvim", config = function()
      require("toggleterm").setup({ size = 20, open_mapping = [[<C-t>]], direction = "horizontal" })
    end,
  },

  -- Treesitter for syntax highlighting
  { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate", config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = { "python", "rust", "java", "cpp" },
        highlight = { enable = true },
        indent = { enable = true },
      })
    end,
  },

  -- LSP configuration with formatting
  { "neovim/nvim-lspconfig", dependencies = { "williamboman/mason.nvim", "williamboman/mason-lspconfig.nvim" },
    config = function()
      require("mason").setup()
      require("mason-lspconfig").setup({
        ensure_installed = { "pyright", "rust_analyzer", "jdtls", "clangd" }
      })
      
      local lspconfig = require("lspconfig")
      lspconfig.pyright.setup({})
      lspconfig.rust_analyzer.setup({})
      lspconfig.jdtls.setup({})
      lspconfig.clangd.setup({})

      -- LSP-based auto-formatting on save
      vim.api.nvim_create_autocmd("BufWritePre", {
        pattern = "*",
        callback = function()
          vim.lsp.buf.format({ async = false })
        end,
      })
    end,
  },

  -- Everforest colorscheme
{ 
  "sainnhe/everforest", 
  priority = 1000,  -- Ensure it loads first
  config = function()
    vim.g.everforest_background = 'soft'
    vim.g.everforest_transparent_background = 1
    vim.cmd("colorscheme everforest")
    
    -- Apply transparency settings after colorscheme
    vim.cmd([[
      highlight Normal guibg=NONE ctermbg=NONE
      highlight NormalNC guibg=NONE ctermbg=NONE
      highlight SignColumn guibg=NONE
      highlight LineNr guibg=NONE
      highlight Folded guibg=NONE
      highlight NonText guibg=NONE
      highlight SpecialKey guibg=NONE
      highlight VertSplit guibg=NONE
      highlight EndOfBuffer guibg=NONE
    ]])
  end,
} 
    
})



print("Minimal Neovim setup loaded!")

