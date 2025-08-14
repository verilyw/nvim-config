-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Setup lazy.nvim
require("lazy").setup({
  spec = {
    -- add your plugins here
    -- lsp 
    { "mason-org/mason.nvim", opts = {} },
    {
        "neovim/nvim-lspconfig",
        config = function() require "config/lspconfig" end
    },
    {
        "mason-org/mason-lspconfig.nvim",
        dependencies = {
            { "mason-org/mason.nvim", opts = {} },
            "neovim/nvim-lspconfig",
        },
        opts = {
            ensure_installed = { "lua_ls", "pylsp" },
        },
    },
    -- cmp
    {
        'hrsh7th/nvim-cmp',
        event = "InsertEnter",
        dependencies = {
            'hrsh7th/cmp-nvim-lsp',
            'hrsh7th/cmp-nvim-lsp-signature-help',
            'hrsh7th/cmp-buffer',
            'hrsh7th/cmp-path',
            'hrsh7th/cmp-cmdline',
            'f3fora/cmp-spell',
            'hrsh7th/cmp-calc',
            'hrsh7th/cmp-emoji',
            'lukas-reineke/cmp-rg',
            -- 'roobert/tailwindcss-colorizer-cmp.nvim',
            "lukas-reineke/cmp-under-comparator",
            "onsails/lspkind-nvim"
        },
        config = function()
            require "config/nvim-cmp"
        end
    },
    -- trouble
    {
        "folke/trouble.nvim",
        config = function()
            require "config/trouble"
        end
    },
    {
        'nvim-treesitter/nvim-treesitter',
        init= function()
            require('nvim-treesitter.install').update({ with_sync = true })
        end,
        config = function() require'config/nvim-treesitter' end,
        dependencies = {
            'p00f/nvim-ts-rainbow',
            'nvim-treesitter/nvim-treesitter-textobjects',
            -- 'nvim-treesitter/nvim-treesitter-context',
            'JoosepAlviste/nvim-ts-context-commentstring',
            'windwp/nvim-ts-autotag',
            'andymass/vim-matchup',
            'mfussenegger/nvim-treehopper',
        },
    },
    -- telescope
    {
        'nvim-telescope/telescope.nvim', tag = '0.1.8',
        config = function() require "config/telescope" end,
          dependencies = { 'nvim-lua/plenary.nvim' }
    },
    -- files and buffer
    {
        "nvim-tree/nvim-tree.lua",
        config = function() require 'config/nvim-tree' end,
        dependencies = {
            "nvim-tree/nvim-web-devicons"
        }
    }
  },
  -- Configure any other settings here. See the documentation for more details.
  -- colorscheme that will be used when installing plugins.
  --  install = { colorscheme = { "habamax" } },
  -- automatically check for plugin updates
  checker = { enabled = false },
})
