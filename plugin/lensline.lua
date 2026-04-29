vim.api.nvim_create_autocmd("LspAttach", {
	once = true,
	callback = function()
		vim.pack.add({
			{ src = "https://github.com/oribarilan/lensline.nvim", version = "release/2.x" },
		})
		require("lensline").setup({
			profiles = {
				{
					name = "minimal",
					style = {
						placement = "inline",
						prefix = "",
						-- render = "focused", optionally render lenses only for focused function
					},
				},
			},
		})
	end,
})
