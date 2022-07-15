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
vim.opt.tabstop = 2

vim.g.mapleader = " "
vim.g.maplocalleader = ","

-- vim.cmd "colorscheme alabaster_light"
vim.cmd "colorscheme alabaster_dark"

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
	use "wbthomason/packer.nvim" -- Package manager
	use 'echasnovski/mini.nvim' -- Lots
	use "chentoast/marks.nvim" -- List marks

	-- Style
	use "grierson/alabaster_light.nvim" -- Light theme
	use "p00f/alabaster_dark.nvim" -- Dark theme
	use "nvim-treesitter/nvim-treesitter" -- Better highlighting
	use "p00f/nvim-ts-rainbow" -- Rainbow parens

	-- Keymapping
	use {
		"folke/which-key.nvim", -- Show keymaps
		config = function()
			require("which-key").setup()
		end
	}

	use { 'norcalli/nvim-colorizer.lua', -- Show hex color
		config = function()
			require('colorizer').setup()
		end
	}

	-- IDE
	use {
		"nvim-telescope/telescope.nvim", -- Search
		requires = {
			"nvim-lua/plenary.nvim"
		}
	}

	use {
		"nvim-neo-tree/neo-tree.nvim", -- Project tree
		requires = {
			"nvim-lua/plenary.nvim",
			"kyazdani42/nvim-web-devicons",
			"MunifTanjim/nui.nvim",
		},
		config = function()
			require("neo-tree").setup()
		end
	}

	-- Git
	use {
		'TimUntersberger/neogit', -- Git changes
		requires = 'nvim-lua/plenary.nvim',
		config = function()
			require("neogit").setup()
		end
	}

	use {
		"lewis6991/gitsigns.nvim", -- List Git changes
		config = function()
			require("gitsigns").setup()
		end
	}

	use {
		'sindrets/diffview.nvim',  -- Git diff
		requires = 'nvim-lua/plenary.nvim'
	}

	-- Markdown
	-- install without yarn or npm
	use {
		"iamcco/markdown-preview.nvim",
		run = function()
			vim.fn["mkdp#util#install"]()
		end
	}

	use { "iamcco/markdown-preview.nvim",
		run = "cd app && npm install",
		setup = function()
			vim.g.mkdp_filetypes = { "markdown" }
		end,
		ft = { "markdown" }
	}

	-- LSP + Autocomplete
	use 'neovim/nvim-lspconfig'
	use 'williamboman/nvim-lsp-installer'

	use 'hrsh7th/nvim-cmp'
	use 'hrsh7th/cmp-nvim-lsp'
	use 'hrsh7th/cmp-buffer'

	use 'saadparwaiz1/cmp_luasnip'
	use 'L3MON4D3/LuaSnip'
	use 'stevearc/dressing.nvim'
	use {
		"folke/trouble.nvim",
		requires = "kyazdani42/nvim-web-devicons"
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

-- Autocomplete
local luasnip = require 'luasnip'
local cmp = require 'cmp'
cmp.setup {
	snippet = {
		expand = function(args)
			luasnip.lsp_expand(args.body)
		end,
	},
	mapping = cmp.mapping.preset.insert({
		['<CR>'] = cmp.mapping.confirm {
			behavior = cmp.ConfirmBehavior.Replace,
			select = true,
		},
		['<Tab>'] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_next_item()
			elseif luasnip.expand_or_jumpable() then
				luasnip.expand_or_jump()
			else
				fallback()
			end
		end, { 'i', 's' }),
		['<S-Tab>'] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_prev_item()
			elseif luasnip.jumpable(-1) then
				luasnip.jump(-1)
			else
				fallback()
			end
		end, { 'i', 's' }),
	}),
	sources = {
		{ name = 'nvim_lsp' },
		{ name = 'luasnip' },
		{ name = 'buffer' },
	},
}

-- LSP + Complete
local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())

-- Docs
require('lspconfig')['marksman'].setup {
	capabilities = capabilities
}

-- Lang
require('lspconfig')['sumneko_lua'].setup {
	capabilities = capabilities
}
require('lspconfig')['clojure_lsp'].setup {
	capabilities = capabilities
}

-- WEB
require('lspconfig')['tsserver'].setup {
	capabilities = capabilities
}
require('lspconfig')['denols'].setup {
	capabilities = capabilities
}
require('lspconfig')['eslint'].setup {
	capabilities = capabilities
}
require('lspconfig')['html'].setup {
	capabilities = capabilities
}
require('lspconfig')['tailwindcss'].setup {
	capabilities = capabilities
}

-- DEVOPS
require('lspconfig')['terraformls'].setup {
	capabilities = capabilities
}
require('lspconfig')['tflint'].setup {
	capabilities = capabilities
}
require('lspconfig')['yamlls'].setup {
	capabilities = capabilities
}
require('lspconfig')['dockerls'].setup {
	capabilities = capabilities
}
require('lspconfig')['bashls'].setup {
	capabilities = capabilities
}

require("nvim-treesitter.configs").setup {
	highlight = {
		enable = true
	},
	indent = {
		enable = true
	},
	rainbow = {
		enable = true,
		extended_mode = true,
		max_file_lines = nil
	}
}

require("marks").setup {}
require("mini.comment").setup {}
require("mini.pairs").setup {}
require("mini.surround").setup {}
require("mini.statusline").setup {}

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
			r = { "<cmd>Telescope registers<cr>", "Registers" },
			s = { "<cmd>Telescope spell_suggest<cr>", "Spelling" },
			e = { "<cmd>Trouble<cr>", "Errors" }
		},
		g = {
			name = "+git",
			s = { "<cmd>Neogit<cr>", "Status" },
			d = { "<cmd>DiffviewOpen<cr>", "Diff" },
		},
		h = { "<cmd>nohl<cr>", "No highlight" },
		t = { "<cmd>NeoTreeFocus<cr>", "Focus tree" },
		T = { "<cmd>NeoTreeShowToggle<cr>", "Toggle tree" },
		l = {
			name = "+LSP",
			a = { "<cmd>lua vim.lsp.buf.code_action()<cr>", "Action" },
			f = { "<cmd>lua vim.lsp.buf.formatting_sync()<cr>", "Format" },
			r = { "<cmd>lua vim.lsp.buf.rename()<cr>", "Rename" },
		},
	},
	["<localleader>"] = {
		name = "+repl",
		r = { "<cmd>ConjureLogVSplit<cr>", "Open REPL" },
	},
})
