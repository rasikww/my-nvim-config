vim.pack.add({
	{ src = "https://github.com/nvim-lua/plenary.nvim" },
	{ src = "https://github.com/neovim/nvim-lspconfig" },
	{ src = "https://github.com/pmizio/typescript-tools.nvim" },
})

require("typescript-tools").setup({
	settings = {
		tsserver_plugins = {},
		separate_diagnostic_server = false,
		expose_as_code_action = "all",
	},
})
