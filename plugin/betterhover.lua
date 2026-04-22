local hover_enabled = true
vim.api.nvim_create_autocmd("FileType", {
	once = true,
	pattern = { "typescript", "typescriptreact", "javascript", "javascriptreact", "tailwindcss", "svelte", "astro" },
	callback = function()
		vim.pack.add({
			{ src = "https://github.com/Sebastian-Nielsen/better-type-hover" },
		})

		require("better-type-hover").setup({
			openTypeDocKeymap = "<S-j>",
		})
	end,
})

vim.keymap.set("n", "<leader>tj", function()
	hover_enabled = not hover_enabled

	if hover_enabled then
		-- Enable Better Hover on Shift+J
		vim.keymap.set("n", "<S-j>", function()
			require("better-type-hover").open_type_doc()
		end, { desc = "Better Hover" })

		print("Better Hover ENABLED")
	else
		-- Restore default J behavior
		vim.keymap.set("n", "<S-j>", "J", { desc = "Default J" })

		print("Better Hover DISABLED")
	end
end, { desc = "[T]oggle Better Hover" })
