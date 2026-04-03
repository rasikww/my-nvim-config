vim.api.nvim_create_autocmd("FileType", {
	once = true,
	pattern = { "typescript", "typescriptreact", "javascript", "javascriptreact", "tailwindcss", "svelte" },
	callback = function()
		vim.pack.add({
			{ src = "https://github.com/Sebastian-Nielsen/better-type-hover" },
		})

		require("better-type-hover").setup({
			openTypeDocKeymap = "<S-j>",
		})
	end,
})
