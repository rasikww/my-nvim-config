vim.pack.add({
	"https://github.com/stevearc/conform.nvim",
})
vim.g.auto_format_enabled = true
require("conform").setup({
	notify_on_error = false,
	format_on_save = function(bufnr)
		if not vim.g.auto_format_enabled then
			return nil
		end
		-- Disable "format_on_save lsp_fallback" for languages that don't
		-- have a well standardized coding style. You can add additional
		-- languages here or re-enable it for the disabled ones.
		local disable_filetypes = { c = true, cpp = true }
		if disable_filetypes[vim.bo[bufnr].filetype] then
			return nil
		else
			return {
				timeout_ms = 2000,
				lsp_format = "fallback",
			}
		end
	end,
	formatters_by_ft = {
		lua = { "stylua" },
		-- Conform can also run multiple formatters sequentially
		python = { "isort", "black", "flake8" },
		--
		-- You can use 'stop_after_first' to run the first available formatter from the list
		javascriptreact = { "prettierd", "prettier", stop_after_first = true },
		javascript = { "prettierd", "prettier", stop_after_first = true },
		typescriptreact = { "prettierd", "prettier", stop_after_first = true },
		typescript = { "prettierd", "prettier", stop_after_first = true }, --changing this because it was conflicting after an npm install
		vue = { "prettierd", "prettier", stop_after_first = true },
		svelte = { "prettierd", "prettier", stop_after_first = true },
		astro = { "prettierd", "prettier", stop_after_first = true },

		-- Markup
		html = { "prettierd", "prettier", stop_after_first = true },
		xml = { "prettierd", "prettier", stop_after_first = true },

		-- Styles
		css = { "prettierd", "prettier", stop_after_first = true },
		scss = { "prettierd", "prettier", stop_after_first = true },
		less = { "prettierd", "prettier", stop_after_first = true },
		stylus = { "prettierd", "prettier", stop_after_first = true },

		-- Data / Config
		json = { "prettierd", "prettier", stop_after_first = true },
		jsonc = { "prettierd", "prettier", stop_after_first = true },
		yaml = { "prettierd", "prettier", stop_after_first = true },
		toml = { "prettierd", "prettier", stop_after_first = true },

		-- Database
		-- sql = { "sql_formatter" },
		["*"] = { "injected" },
		prisma = { "prettierd", "prettier", stop_after_first = true },
		dbml = { "prettierd", "prettier", stop_after_first = true },

		-- Markdown
		markdown = { "prettierd", "prettier", stop_after_first = true },
		mdx = { "prettierd", "prettier", stop_after_first = true },

		-- Misc Config
		conf = { "prettierd", "prettier", stop_after_first = true },
		ini = { "prettierd", "prettier", stop_after_first = true },
		dotenv = { "prettierd", "prettier", stop_after_first = true },

		-- Shell
		sh = { "prettierd", "prettier", stop_after_first = true },
		bash = { "prettierd", "prettier", stop_after_first = true },
	},
	formatters = {
		sql_formatter = {
			prepend_args = { "-l", "postgresql", "--config", [[{"expressionWidth": 80, "keywordCase": "upper"}]] },
		},
	},
})

vim.keymap.set("n", "<leader>f", function()
	local filetype = vim.bo.filetype
	if filetype == "zig" or filetype == "zon" then
		vim.lsp.buf.format({ async = false })
	else
		require("conform").format({ async = true, lsp_format = "fallback" })
	end
end, { desc = "[F]ormat buffer" })

vim.keymap.set("n", "<leader>tf", function()
	vim.g.auto_format_enabled = not vim.g.auto_format_enabled
	local status = vim.g.auto_format_enabled and "enabled" or "disabled"
	vim.notify("Auto-format on save: " .. status, vim.log.levels.INFO)
end, { desc = "[T]oggle [F]ormat on save" })

vim.api.nvim_create_autocmd("BufWritePre", {
	pattern = { "*.zig", "*.zon" },
	callback = function()
		-- Only format if the global flag is true (or nil, assuming enabled by default)
		if vim.g.auto_format_enabled ~= false then
			vim.lsp.buf.format({ async = false })
		end
	end,
	desc = "Auto-format Zig files on save",
})
