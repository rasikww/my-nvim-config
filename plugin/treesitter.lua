vim.env.CC = vim.fn.exepath("gcc") .. " cc"
--for windows make sure to install MSYS2 using winget and then gcc using MSYS2 UCRT64
--and then add the gcc to the path variable of the environment
local ensure_installed = {
	"bash",
	"c",
	"css",
	"dart",
	"diff",
	"dockerfile",
	"git_config",
	"html",
	"lua",
	"luadoc",
	"markdown",
	"markdown_inline",
	"query",
	"sql",
	"toml",
	"vim",
	"vimdoc",
	"typescript",
	"javascript",
	"python",
	"json",
	"yaml",
}

vim.pack.add({
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter", version = "main" },
})

require("nvim-treesitter.install").compilers = { "gcc" }
require("nvim-treesitter").install(ensure_installed)

vim.api.nvim_create_autocmd("FileType", {
	callback = function()
		local lang = vim.treesitter.language.get_lang(vim.bo.filetype)
		if lang then
			pcall(vim.treesitter.start)
		end
	end,
})

-- vim.api.nvim_create_autocmd('FileType', {
--   pattern = { '*' },
--   callback = function()
--     if vim.bo.filetype ~= 'ruby' then
--       -- Only try to use TS indent if the plugin is actually loaded
--       pcall(function()
--         vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
--       end)
--     end
--   end,
-- })
