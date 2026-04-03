vim.pack.add({
	{ src = "https://github.com/catgoose/nvim-colorizer.lua" },
})

vim.api.nvim_create_autocmd("VimEnter", {
	once = true,
	callback = function()
		require("colorizer").setup({
			user_default_options = {
				oklch_fn = true,
				RGB = true,
				RRGGBB = true,
				names = true,
				RRGGBBAA = false,
				rgb_fn = false,
				hsl_fn = true,
				css = false,
				css_fn = false,
				mode = "background",
				tailwind = true,
				tailwind_opts = { -- Options for highlighting tailwind names
					update_names = true, -- When using tailwind = 'both', update tailwind names from LSP results.  See tailwind section
				},
			},
		})
	end,
})
