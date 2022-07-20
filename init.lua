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
vim.o.signcolumn = "yes"

vim.g.mapleader = " "
vim.g.maplocalleader = ","

-- vim.cmd "colorscheme alabaster_light"
vim.cmd("colorscheme alabaster_light")
vim.cmd("set noswapfile")

-- Packer
local fn = vim.fn

-- Automatically install packer
local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
	PACKER_BOOTSTRAP = fn.system({
		"git",
		"clone",
		"--depth",
		"1",
		"https://github.com/wbthomason/packer.nvim",
		install_path,
	})
	print("Installing packer close and reopen Neovim...")
	vim.cmd([[packadd packer.nvim]])
end

-- Use a protected call so we don't error out on first use
local status_ok, packer = pcall(require, "packer")
if not status_ok then
	return
end

packer.startup(function(use)
	-- Setup
	use("wbthomason/packer.nvim") -- Package manager
	use("echasnovski/mini.nvim") -- Lots
	use("nvim-lua/plenary.nvim") -- Lots
	use("chentoast/marks.nvim") -- List marks

	-- Style
	use("rktjmp/lush.nvim")
	use("grierson/alabaster_light.nvim")
	use("p00f/alabaster_dark.nvim") -- Dark theme
	use("nvim-treesitter/nvim-treesitter") -- Better highlighting
	use("p00f/nvim-ts-rainbow") -- Rainbow parens
	use({
		"nvim-lualine/lualine.nvim",
		requires = { "kyazdani42/nvim-web-devicons", opt = true },
	})

	-- Keymapping
	use({
		"folke/which-key.nvim", -- Show keymaps
		config = function()
			require("which-key").setup()
		end,
	})

	use({
		"norcalli/nvim-colorizer.lua", -- Show hex color
		config = function()
			require("colorizer").setup()
		end,
	})

	-- IDE
	use({
		"nvim-telescope/telescope.nvim", -- Search
		requires = {
			"nvim-lua/plenary.nvim",
		},
	})

	use({
		"nvim-neo-tree/neo-tree.nvim", -- Project tree
		requires = {
			"nvim-lua/plenary.nvim",
			"kyazdani42/nvim-web-devicons",
			"MunifTanjim/nui.nvim",
		},
		config = function()
			require("neo-tree").setup()
		end,
	})

	-- Git
	use({
		"TimUntersberger/neogit", -- Git changes
		requires = "nvim-lua/plenary.nvim",
		config = function()
			require("neogit").setup()
		end,
	})

	use({
		"lewis6991/gitsigns.nvim", -- List Git changes
		config = function()
			require("gitsigns").setup()
		end,
	})

	use({
		"sindrets/diffview.nvim", -- Git diff
		requires = "nvim-lua/plenary.nvim",
	})

	-- Markdown
	use({
		"iamcco/markdown-preview.nvim",
		run = "cd app && npm install",
		setup = function()
			vim.g.mkdp_filetypes = { "markdown" }
		end,
		ft = { "markdown" },
	})

	-- LSP + Autocomplete
	use("neovim/nvim-lspconfig")
	use("williamboman/nvim-lsp-installer")

	use("hrsh7th/nvim-cmp")
	use("hrsh7th/cmp-nvim-lsp")
	use("hrsh7th/cmp-buffer")

	use("saadparwaiz1/cmp_luasnip")
	use("L3MON4D3/LuaSnip")
	use("stevearc/dressing.nvim")
	use({
		"folke/trouble.nvim",
		requires = "kyazdani42/nvim-web-devicons",
	})

	-- Clojure
	use("Olical/aniseed")
	use("Olical/conjure")
	use("clojure-vim/vim-jack-in")
	use("tpope/vim-dispatch")
	use("radenling/vim-dispatch-neovim")
	use("guns/vim-sexp")
	use("tpope/vim-sexp-mappings-for-regular-people")

	-- Put this at the end after all plugins
	if PACKER_BOOTSTRAP then
		require("packer").sync()
	end
end)

-- Autocomplete
local luasnip = require("luasnip")
local cmp = require("cmp")
cmp.setup({
	snippet = {
		expand = function(args)
			luasnip.lsp_expand(args.body)
		end,
	},
	mapping = cmp.mapping.preset.insert({
		["<CR>"] = cmp.mapping.confirm({
			behavior = cmp.ConfirmBehavior.Replace,
			select = true,
		}),
		["<Tab>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_next_item()
			elseif luasnip.expand_or_jumpable() then
				luasnip.expand_or_jump()
			else
				fallback()
			end
		end, { "i", "s" }),
		["<S-Tab>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_prev_item()
			elseif luasnip.jumpable(-1) then
				luasnip.jump(-1)
			else
				fallback()
			end
		end, { "i", "s" }),
	}),
	sources = {
		{ name = "nvim_lsp" },
		{ name = "luasnip" },
		{ name = "buffer" },
	},
})

-- LSP + Complete
local capabilities = require("cmp_nvim_lsp").update_capabilities(vim.lsp.protocol.make_client_capabilities())

local servers = {
	"sumneko_lua",
	"clojure_lsp",
	"tsserver",
	"eslint",
	"html",
	"tailwindcss",
	"marksman",
	"terraformls",
	"tflint",
	"yamlls",
	"dockerls",
	"bashls",
}

for _, lsp in ipairs(servers) do
	require("lspconfig")[lsp].setup({
		capabilities = capabilities
	})
end

require("nvim-treesitter.configs").setup({
	highlight = {
		enable = true,
	},
	indent = {
		enable = true,
	},
	rainbow = {
		enable = true,
		extended_mode = true,
		max_file_lines = nil,
	},
})

require('lualine').setup({
	options = {
		theme = 'onelight'
	}
})
require("marks").setup({})
require("mini.comment").setup({})
require("mini.pairs").setup({})
require("mini.surround").setup({})
require("mini.test").setup({})

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
			e = { "<cmd>Trouble<cr>", "Errors" },
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
		t = {
			name = "+test",
			f = { "<cmd>PlenaryBustedDirectory .<cr>", "run test" },
		},
	},
})
