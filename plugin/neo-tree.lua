vim.pack.add({
	--dependencies
	{ src = "https://github.com/nvim-lua/plenary.nvim" },
	{ src = "https://github.com/nvim-tree/nvim-web-devicons" },
	{ src = "https://github.com/MunifTanjim/nui.nvim" },
	{ src = "https://github.com/antosha417/nvim-lsp-file-operations" },
	--actual plugin
	{ src = "https://github.com/nvim-neo-tree/neo-tree.nvim", version = "v3.x" },
})

require("lsp-file-operations").setup()

require("neo-tree").setup({
	filesystem = {
		window = {
			position = "float",
			float = {
				width = "80%", -- Example: 80% of screen width
				height = "80%", -- Example: 80% of screen height
				position = "50%", -- Example: Center the float
			},
			mappings = {
				["\\"] = "close_window",
				["l"] = "open", -- open file or expand dir
				["h"] = "close_node",
				["<C-f>"] = "none",
				["<C-b>"] = "none",
				["<C-u>"] = { "scroll_preview", config = { direction = 10 } },
				["<C-d>"] = { "scroll_preview", config = { direction = -10 } },
			},
		},
	},
})

vim.keymap.set({ "n", "v" }, "\\", "<cmd>Neotree reveal<cr>", { desc = "NeoTree Reveal", silent = true })
