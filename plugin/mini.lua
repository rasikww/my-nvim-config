vim.pack.add({ "https://github.com/nvim-mini/mini.nvim" })
-- vim.cmd.colorscheme("miniwinter")
require("mini.basics").setup()
require("mini.move").setup()
require("mini.ai").setup()
require("mini.cursorword").setup()
require("mini.surround").setup()
require("mini.pairs").setup()
-- require("mini.jump2d").setup()

local statusline = require("mini.statusline")
statusline.setup({ use_icons = vim.g.have_nerd_font })
-- You can configure sections in the statusline by overriding their
-- default behavior. For example, here we set the section for
-- cursor location to LINE:COLUMN
---@diagnostic disable-next-line: duplicate-set-field
statusline.section_location = function()
	return "%2l:%-2v"
end
