vim.cmd("set expandtab")
vim.cmd("set tabstop=4")
vim.cmd("set softtabstop=4")
vim.cmd("set shiftwidth=4")
vim.cmd("set nu")
vim.cmd("set clipboard=unnamedplus")
vim.cmd("autocmd TextYankPost * silent! lua vim.highlight.on_yank {higroup='Visual', timeout=300}")
vim.o.termguicolors = true
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

vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

require("lazy").setup({
	spec = {
		{
			"scottmckendry/cyberdream.nvim",
			lazy = false,
			priority = 1000,
		},
		"nvim-telescope/telescope.nvim",
		{
			"nvim-treesitter/nvim-treesitter",
			dependencies = { "nvim-lua/plenary.nvim" },
			build = ":TSUpdate",
			config = function()
				local configs = require("nvim-treesitter.configs")
				configs.setup({
					ensure_installed = { "c_sharp", "html", "markdown", "python", "lua" },
					sync_install = true,
					highlight = { enable = true },
					indent = { enable = true },
				})
			end,
		},
		"williamboman/mason.nvim",
		"williamboman/mason-lspconfig.nvim",
		"neovim/nvim-lspconfig",
		{
			"nvim-neo-tree/neo-tree.nvim",
			dependencies = {
				"nvim-lua/plenary.nvim",
				"nvim-tree/nvim-web-devicons",
				"MunifTanjim/nui.nvim",
			},
			config = function()
				require("neo-tree").setup({
					filesystem = {
						filtered_items = {
							hide_dotfiles = false,
							hide_gitignored = false,
						},
					},
				})
			end,
		},
		{
			"nvim-lualine/lualine.nvim",
			dependencies = { "nvim-tree/nvim-web-devicons" },
		},
		"nvim-telescope/telescope-ui-select.nvim",
		"Hoffs/omnisharp-extended-lsp.nvim",
		{
			"nvimtools/none-ls.nvim",
			dependencies = {
				"nvimtools/none-ls-extras.nvim",
			},
		},
		"terrortylor/nvim-comment",
		"hrsh7th/nvim-cmp",
		"hrsh7th/cmp-nvim-lsp",
		{
			"L3MON4D3/LuaSnip",
			dependencies = "rafamadriz/friendly-snippets",
		},
		"saadparwaiz1/cmp_luasnip",
		"windwp/nvim-ts-autotag",
		"andweeb/presence.nvim",
		{
			"nvimdev/lspsaga.nvim",
			config = function()
				require("lspsaga").setup({})
			end,
			dependencies = {
				"nvim-treesitter/nvim-treesitter", -- optional
				"nvim-tree/nvim-web-devicons", -- optional
			},
		},
		{
			"kdheepak/lazygit.nvim",
			cmd = {
				"LazyGit",
				"LazyGitConfig",
				"LazyGitCurrentFile",
				"LazyGitFilter",
				"LazyGitFilterCurrentFile",
			},
			-- optional for floating window border decoration
			dependencies = {
				"nvim-lua/plenary.nvim",
			},
			-- setting the keybinding for LazyGit with 'keys' is recommended in
			-- order to load the plugin when the command is run for the first time
			keys = {
				{ "<leader>lg", "<cmd>LazyGit<cr>", desc = "LazyGit" },
			},
		},
		"norcalli/nvim-colorizer.lua",
		"lewis6991/gitsigns.nvim",
		{
			"romgrk/barbar.nvim",
			dependencies = {
				"lewis6991/gitsigns.nvim", -- OPTIONAL: for git status
				"nvim-tree/nvim-web-devicons", -- OPTIONAL: for file icons
			},
		},
		"stevearc/vim-arduino",
		"daeyun/vim-matlab",
		"windwp/nvim-ts-autotag",
		{
			"MeanderingProgrammer/render-markdown.nvim",
			dependencies = { "nvim-treesitter/nvim-treesitter", "echasnovski/mini.icons" },
			---@module 'render-markdown'
			---@type render.md.UserConfig
			opts = {},
		},
		{
			"lervag/vimtex",
			lazy = false, -- we don't want to lazy load VimTeX
			-- tag = "v2.15", -- uncomment to pin to a specific release
			init = function()
				-- VimTeX configuration goes here, e.g.
				vim.g.vimtex_view_method = "zathura"
			end,
		},
	},
	install = { colorscheme = { "cyberdream" } },
	checker = { enabled = true },
})

local cmp = require("cmp")

cmp.setup({
	snippet = {
		expand = function(args)
			require("luasnip").lsp_expand(args.body)
		end,
	},
	window = {
		completion = cmp.config.window.bordered(),
		documentation = cmp.config.window.bordered(),
	},
	mapping = cmp.mapping.preset.insert({
		["<C-b>"] = cmp.mapping.scroll_docs(-4),
		["<C-f>"] = cmp.mapping.scroll_docs(4),
		["<C-Space>"] = cmp.mapping.complete(),
		["<C-e>"] = cmp.mapping.abort(),
		["<CR>"] = cmp.mapping.confirm({ select = true }),
	}),
	sources = cmp.config.sources({
		-- { name = "nvim_lsp" },
		{ name = "luasnip" }, -- For luasnip users.
	}, {
		{ name = "buffer" },
	}),
})
local colors = {
	blue = "#80a0ff",
	cyan = "#79dac8",
	black = "#080808",
	white = "#c6c6c6",
	red = "#ff5189",
	violet = "#d183e8",
	grey = "#303030",
}

local bubbles_theme = {
	normal = {
		a = { fg = colors.black, bg = colors.violet },
		b = { fg = colors.white, bg = colors.grey },
		c = { fg = colors.white },
	},

	insert = { a = { fg = colors.black, bg = colors.blue } },
	visual = { a = { fg = colors.black, bg = colors.cyan } },
	replace = { a = { fg = colors.black, bg = colors.red } },

	inactive = {
		a = { fg = colors.white, bg = colors.black },
		b = { fg = colors.white, bg = colors.black },
		c = { fg = colors.white },
	},
}

if vim.g.neovide then
	-- vim.g.neovide_fullscreen = true
	vim.g.neovide_scale_factor = 0.8
	local change_scale_factor = function(delta)
		vim.g.neovide_scale_factor = vim.g.neovide_scale_factor * delta
	end
	vim.keymap.set("n", "<C-=>", function()
		change_scale_factor(1.25)
	end)
	vim.keymap.set("n", "<C-->", function()
		change_scale_factor(0.8)
	end)
end

vim.g.arduino_dir = "/usr/share/arduino"
vim.g.arduino_home_dir = "$HOME/.arduino15"

local function arduino_status()
	if vim.bo.filetype ~= "arduino" then
		return ""
	end
	local port = vim.fn["arduino#GetPort"]()
	local line = string.format("[%s]", vim.g.arduino_board)
	if vim.g.arduino_programmer ~= "" then
		line = line .. string.format(" [%s]", vim.g.arduino_programmer)
	end
	if port ~= 0 then
		line = line .. string.format(" (%s:%s)", port, vim.g.arduino_serial_baud)
	end
	return line
end

require("lualine").setup({
	options = {
		theme = bubbles_theme,
		component_separators = "",
		section_separators = { left = "", right = "" },
	},
	sections = {
		lualine_a = { { "mode", separator = { left = "" }, right_padding = 2 } },
		lualine_b = { "filename", "branch", "diff", "diagnostics", arduino_status },
		lualine_c = { "%=" },
		lualine_x = {},
		lualine_y = { "filetype", "progress", { 'datetime', style = '%a %-m/%-d %-I:%M%P' } },
		lualine_z = {
			{ "location", separator = { right = "" }, left_padding = 2 },
		},
	},
	inactive_sections = {
		lualine_a = { "filename" },
		lualine_b = {},
		lualine_c = {},
		lualine_x = {},
		lualine_y = {},
		lualine_z = { "location" },
	},
	tabline = {},
	extensions = { "lazy", "mason" },
})

require("cmp").setup({
	sources = {
		{ name = "nvim_lsp" },
	},
})

local capabilities = require("cmp_nvim_lsp").default_capabilities()


require("nvim_comment").setup()

require("mason").setup()

require("gitsigns").setup()

require("mason-lspconfig").setup({
	ensure_installed = {
		"lua_ls",
		"omnisharp_mono",
		"html",
		"basedpyright",
		"ruff",
		"marksman",
		"biome",
		"clangd",
		"matlab_ls",
		"rust_analyzer",
		"arduino_language_server",
		"kotlin_language_server",
		"gradle_ls",
	},
})

require("nvim-ts-autotag").setup({
	opts = {
		enable_close = true,
		enable_rename = true,
		enable_close_on_slash = true,
	},
})

local lspconfig = require("lspconfig")
local pid = vim.fn.getpid()
lspconfig.lua_ls.setup({ capabilities = capabilities, settings = { Lua = { diagnostics = { globals = { "vim" } } } } })
lspconfig.omnisharp_mono.setup({
	capabilities = capabilities,
	cmd = {
        "$HOME/.local/share/nvim/mason/packages/omnisharp-mono/omnisharp-mono",
		"--languageserver",
		"--hostPID",
		tostring(pid),
	},
	enable_import_completion = true,
	organize_imports_on_format = true,
	enable_roslyn_analyzers = true,
	root_dir = function()
		return vim.loop.cwd() -- current working directory
	end,
})
lspconfig.html.setup({ capabilities = capabilities })
lspconfig.basedpyright.setup({ capabilities = capabilities })
lspconfig.ruff.setup({ capabilities = capabilities })
lspconfig.marksman.setup({ capabilities = capabilities })
lspconfig.biome.setup({
    capabilities = capabilities,
	root_dir = function()
		return vim.loop.cwd() -- current working directory
	end,
})
lspconfig.clangd.setup({ capabilities = capabilities, filetypes = { "c", "cpp", "objc", "objcpp", "cuda", "proto", "ino" } })
lspconfig.matlab_ls.setup({
	capabilities = capabilities,
	filetypes = { "matlab" },
	settings = {
		matlab = {
			installPath = "/usr/local/matlab/R2024b/",
		},
	},
	single_file_support = true,
})
lspconfig.rust_analyzer.setup({ capabilities = capabilities })
lspconfig.arduino_language_server.setup({
    capabilities = capabilities,
    cmd = {
        "/home/kasra/.local/share/nvim/mason/packages/arduino-language-server/arduino-language-server",
        "-board-name",
        '"Arduino Uno"',
		"-clangd",
		"/home/kasra/.local/share/nvim/mason/packages/clangd/clangd_19.1.2/bin/clangd",
		"-cli",
		"/usr/bin/arduino-cli",
		"-cli-config",
		"/home/kasra/.arduino15/arduino-cli.yaml",
        "-fqbn",
        "arduino:avr:uno"
    }
})
lspconfig.kotlin_language_server.setup({ capabilities = capabilities })
lspconfig.gradle_ls.setup({ capabilities = capabilities })

require("telescope").setup({
	extensions = {
		["ui-select"] = {
			require("telescope.themes").get_dropdown({}),
		},
	},
})
require("telescope").load_extension("ui-select")
local null_ls = require("null-ls")
null_ls.setup({
	sources = {
		null_ls.builtins.formatting.stylua,
		null_ls.builtins.formatting.csharpier,
	},
})

require("luasnip.loaders.from_vscode").lazy_load()

vim.diagnostic.config({
	float = {
		source = "always",
	},
})

require("colorizer").setup()
vim.cmd.colorscheme("cyberdream")
local builtin = require("telescope.builtin")
vim.keymap.set("n", "<C-g>", builtin.find_files, {})
vim.keymap.set("n", "<C-f>", builtin.live_grep, {})
vim.keymap.set("n", "<leader>a", ":Neotree toggle<CR>", {})
vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
	border = "rounded",
})
vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
	border = "rounded",
})
vim.keymap.set("n", "gD", vim.lsp.buf.declaration, {})
vim.keymap.set("n", "gd", vim.lsp.buf.definition, {})
vim.keymap.set("n", "gr", ":Lspsaga rename<CR>", {})
vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, {})
vim.keymap.set("n", "<leader>gf", vim.lsp.buf.format, {})
vim.keymap.set("n", "<leader>x", ":!./%<CR>", {})
vim.keymap.set("n", "<Esc>", ":nohl<CR>", {})
vim.keymap.set("n", "<leader>lu", ":Lazy update<CR>", {})
vim.keymap.set("n", "<leader>hd", vim.diagnostic.open_float, {})

local opts = { noremap = true, silent = true }
vim.keymap.set("n", "<A-1>", "<Cmd>BufferGoto 1<CR>", opts)
vim.keymap.set("n", "<A-2>", "<Cmd>BufferGoto 2<CR>", opts)
vim.keymap.set("n", "<A-3>", "<Cmd>BufferGoto 3<CR>", opts)
vim.keymap.set("n", "<A-4>", "<Cmd>BufferGoto 4<CR>", opts)
vim.keymap.set("n", "<A-5>", "<Cmd>BufferGoto 5<CR>", opts)
vim.keymap.set("n", "<A-6>", "<Cmd>BufferGoto 6<CR>", opts)
vim.keymap.set("n", "<A-7>", "<Cmd>BufferGoto 7<CR>", opts)
vim.keymap.set("n", "<A-8>", "<Cmd>BufferGoto 8<CR>", opts)
vim.keymap.set("n", "<A-9>", "<Cmd>BufferGoto 9<CR>", opts)
vim.keymap.set("n", "<A-0>", "<Cmd>BufferLast<CR>", opts)
vim.g.markdown_fenced_languages = { "cs", "python", "arduino", "javascript", "cpp" }
