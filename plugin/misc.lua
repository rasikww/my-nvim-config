vim.pack.add({
	{ src = "https://github.com/nvim-lua/plenary.nvim" },
	{ src = "https://github.com/lukas-reineke/indent-blankline.nvim", name = "ibl" },
	{ src = "https://github.com/folke/todo-comments.nvim" },
})

require("ibl").setup({})
require("todo-comments").setup({})

--TODO:
--NOTE:
--PERF:
--WARNING:
--HACK:
--FIX:
--TEST:

require("vim._core.ui2").enable()
