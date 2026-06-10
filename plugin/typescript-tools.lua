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
		jsx_close_tag = {
			enable = true,
			filetypes = { "javascriptreact", "typescriptreact" },
		},
	},
	spawn_with_args = {
		-- Prevents loading massive global structures for files outside root tsconfig
		"--useInferredProjectPerProjectRoot",
		-- Stops the server from spinning up tasks on background file edits
		"--noGetErrOnBackgroundUpdate",
	},
})
