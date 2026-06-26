vim.pack.add({
	{ src = "https://github.com/nvim-lua/plenary.nvim" },
	{ src = "https://github.com/lukas-reineke/indent-blankline.nvim", name = "ibl" },
	{ src = "https://github.com/folke/todo-comments.nvim" },
	{ src = "https://github.com/JoosepAlviste/nvim-ts-context-commentstring" },
	{ src = "https://github.com/numToStr/Comment.nvim" },
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

require("Comment").setup({
	pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
})
