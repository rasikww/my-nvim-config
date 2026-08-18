-- vim.env.CC = vim.fn.exepath("gcc") .. " cc"
-- vim.env.CC = "zig cc"
vim.env.PATH = "C:\\msys64\\ucrt64\\bin;" .. vim.env.PATH
vim.env.CC = "gcc"
vim.env.CXX = "g++"

-- 3. Fix the Windows extended long-path bug (\\?\C:\...) for MSYS2
local tmp = "C:\\Temp"
if vim.fn.isdirectory(tmp) == 0 then
	vim.fn.mkdir(tmp, "p")
end
vim.env.TEMP = tmp
vim.env.TMP = tmp
--for windows make sure to install MSYS2 using winget and then gcc using MSYS2 UCRT64
--and then add the gcc to the path variable of the environment
local ensure_installed = {
	"bash",
	"c",
	"cpp",
	"css",
	"dart",
	"diff",
	"dockerfile",
	"git_config",
	"html",
	"lua",
	"luadoc",
	"make",
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
	"zig", -- for zig if gcc cannot build it clone the "https://github.com/tree-sitter-grammars/tree-sitter-zig" repo and run "zig cc -shared -o zig.so -O2 src/parser.c -I src" then copy zig.so file to the "neovim_data_directory/site/parser" and copy queries scm files to "neovim_data_directory/site/queries/zig"
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
