vim.api.nvim_create_autocmd("VimEnter", {
	once = true,
	callback = function()
		vim.pack.add({
			{ src = "https://github.com/rafamadriz/friendly-snippets" },
			{ src = "https://github.com/saghen/blink.cmp", version = "v1.9.1" },
		})

		require("blink.cmp").setup({
			keymap = {
				preset = "default",
				["<C-d>"] = { "scroll_documentation_down", "fallback" },
				["<C-u>"] = { "scroll_documentation_up", "fallback" },
			},

			appearance = {
				-- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
				-- Adjusts spacing to ensure icons are aligned
				nerd_font_variant = "mono",
			},

			completion = {
				-- By default, you may press `<c-space>` to show the documentation.
				-- Optionally, set `auto_show = true` to show the documentation after a delay.
				documentation = { auto_show = true, auto_show_delay_ms = 500 },
				menu = {
					auto_show = true,
					draw = {
						treesitter = { "lsp" },
						columns = {
							{ "kind_icon" },
							{ "label", "label_description", gap = 1 },
							{ "kind" },
						},
					},
				},
			},

			sources = {
				default = { "lsp", "path", "snippets" },
				providers = {},
			},
			snippets = {},
			fuzzy = {
				implementation = "prefer_rust_with_warning",
				prebuilt_binaries = {
					download = true,
					ignore_version_mismatch = false,
					force_version = "v1.9.1",
				},
			},
			signature = { enabled = true },
		})
	end,
})
