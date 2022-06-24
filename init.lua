-- :help options

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.ignorecase = true
vim.opt.clipboard = "unnamedplus"
vim.opt.mouse = "a"
vim.opt.termguicolors = true
vim.opt.wrap = false
vim.opt.colorcolumn = "80"
vim.opt.shiftwidth = 2

vim.g.mapleader = " "
vim.g.maplocalleader = ","

vim.g.alabaster_dim_comments = true
vim.cmd "colorscheme alabaster_dark"

require("impatient")

-- Packer
local fn = vim.fn

-- Automatically install packer
local install_path = fn.stdpath "data" .. "/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
	PACKER_BOOTSTRAP = fn.system {
		"git",
		"clone",
		"--depth",
		"1",
		"https://github.com/wbthomason/packer.nvim",
		install_path,
	}
	print "Installing packer close and reopen Neovim..."
	vim.cmd [[packadd packer.nvim]]
end

-- Use a protected call so we don't error out on first use
local status_ok, packer = pcall(require, "packer")
if not status_ok then
	return
end

packer.startup(function(use)
	-- Setup
	use "wbthomason/packer.nvim"
	use "p00f/alabaster_dark.nvim"
	use "nvim-treesitter/nvim-treesitter"
	use "lewis6991/impatient.nvim"
	use {
		"p00f/nvim-ts-rainbow",
		config = function()
			require("nvim-treesitter.configs").setup {
				rainbow = {
					enable = true,
					extended_mode = true,
					max_file_lines = nil
				}
			}
		end
	}

	-- Keymapping
	use {
		"folke/which-key.nvim",
		config = function()
			require("which-key").setup {}
		end
	}

	-- Editing
	use "tpope/vim-surround"
	use {
		"numToStr/Comment.nvim",
		config = function()
			require("Comment").setup()
		end
	}
	use {
		"windwp/nvim-autopairs",
		config = function()
			require("nvim-autopairs").setup {}
		end
	}

	-- IDE
	use {
		"nvim-telescope/telescope.nvim",
		requires = {
			"nvim-lua/plenary.nvim"
		}
	}

	use {
		"nvim-neo-tree/neo-tree.nvim",
		requires = {
			"nvim-lua/plenary.nvim",
			"kyazdani42/nvim-web-devicons",
			"MunifTanjim/nui.nvim",
		},
		config = function()
			require("neo-tree").setup {}
		end
	}

	use {
		"lewis6991/gitsigns.nvim",
		config = function()
			require("gitsigns").setup {}
		end
	}

	-- LSP
	use {
		"VonHeikemen/lsp-zero.nvim",
		requires = {
			-- LSP Support
			{ "neovim/nvim-lspconfig" },
			{ "williamboman/nvim-lsp-installer" },

			-- Autocompletion
			{ "hrsh7th/nvim-cmp" },
			{ "hrsh7th/cmp-buffer" },
			{ "hrsh7th/cmp-path" },
			{ "saadparwaiz1/cmp_luasnip" },
			{ "hrsh7th/cmp-nvim-lsp" },
			{ "hrsh7th/cmp-nvim-lua" },

			-- Snippets
			{ "L3MON4D3/LuaSnip" },
			{ "rafamadriz/friendly-snippets" },
		}
	}

	use {
		"folke/trouble.nvim",
		requires = "kyazdani42/nvim-web-devicons",
		config = function()
			require("trouble").setup {}
		end
	}

	-- Clojure
	use "Olical/conjure"
	use "clojure-vim/vim-jack-in"
	use "tpope/vim-dispatch"
	use "radenling/vim-dispatch-neovim"
	use "guns/vim-sexp"
	use "tpope/vim-sexp-mappings-for-regular-people"

	-- Put this at the end after all plugins
	if PACKER_BOOTSTRAP then
		require("packer").sync()
	end
end)

local lsp = require("lsp-zero")
lsp.preset("recommended")
lsp.setup()

local wk = require("which-key")
wk.register({
	["<leader>"] = {
		f = {
			name = "+find",
			f = { "<cmd>Telescope find_files<cr>", "File" },
			b = { "<cmd>Telescope buffers<cr>", "Buffer" },
			m = { "<cmd>Telescope marks<cr>", "Mark" },
			h = { "<cmd>Telescope help_tags<cr>", "Help" },
			g = { "<cmd>Telescope live_grep<cr>", "Grep" },
			w = { "<cmd>Telescope grep_string<cr>", "Word" },
			e = { "<cmd>Trouble<cr>", "Errors" }
		},
		t = { "<cmd>NeoTreeFocus<cr>", "Focus tree" },
		T = { "<cmd>NeoTreeShowToggle<cr>", "Toggle tree" }
	},
	["<localleader>"] = {
		name = "+lsp",
		f = { "<cmd>LspZeroFormat<cr>", "Format" },
	},
})
