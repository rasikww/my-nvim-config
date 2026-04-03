vim.pack.add({
	--dependencies
	{ src = "https://github.com/nvim-tree/nvim-web-devicons" },
	--actual plugin
	{ src = "https://github.com/akinsho/bufferline.nvim", version = "main" },
})

local function get_smart_buffer_name(buf)
	-- Ensure we have a valid buffer handle; default to 0 (current) if nil
	buf = buf or 0
	local full_path = vim.api.nvim_buf_get_name(buf)

	if full_path == "" then
		return "[No Name]"
	end

	-- Normalize slashes (converts all \ to /) for consistent matching
	full_path = vim.fs.normalize(full_path)
	local name = vim.fn.fnamemodify(full_path, ":t")

	local all_bufs = vim.api.nvim_list_bufs()
	local is_duplicate = false

	-- 1. Check for name collisions across all listed buffers
	for _, other_buf in ipairs(all_bufs) do
		if other_buf ~= buf and vim.bo[other_buf].buflisted then
			local other_path = vim.fs.normalize(vim.api.nvim_buf_get_name(other_buf))
			local other_name = vim.fn.fnamemodify(other_path, ":t")

			if name == other_name then
				is_duplicate = true
				break
			end
		end
	end

	-- 2. Return the "Parent/File" if duplicate, otherwise just "File"
	if is_duplicate then
		-- Matches the last two parts separated by /
		-- Since we normalized, we only need to look for /
		return full_path:match("([^/]+/[^/]+)$") or name
	else
		return name
	end
end

require("bufferline").setup({
	options = {
		mode = "buffers",
		style_preset = require("bufferline").style_preset.default,
		themable = true,
		numbers = "ordinal",
		close_command = "bdelete! %d",
		indicator = {
			-- icon = "▎",
			style = "underline",
		},
		name_formatter = function(buf)
			return get_smart_buffer_name(buf["bufnr"])
		end,
		separator_style = "thin",
		always_show_bufferline = true,
		diagnostics = "nvim_lsp",
		diagnostics_update_on_event = true, -- use nvim's diagnostic handler
		offsets = {
			{
				filetype = "neo-tree",
				text = "File Explorer",
				text_align = "left",
				separator = true,
			},
		},
	},
	highlights = {
		buffer_selected = {
			fg = {
				attribute = "bg",
				highlight = "000000",
			},
			bg = {
				attribute = "fg",
				highlight = "ffffff",
			},
		},
		close_button_selected = {
			fg = {
				attribute = "bg",
				highlight = "000000",
			},
			bg = {
				attribute = "fg",
				highlight = "ffffff",
			},
		},
		numbers_selected = {
			fg = {
				attribute = "bg",
				highlight = "000000",
			},
			bg = {
				attribute = "fg",
				highlight = "ffffff",
			},
		},
	},
})

for i = 1, 9 do
	vim.keymap.set("n", "<leader>" .. i, function()
		require("bufferline").go_to(i, true)
	end, { desc = "Go to buffer " .. i })
end

-- Optional: map <leader>0 to go to the last buffer
vim.keymap.set("n", "<leader>0", function()
	require("bufferline").go_to(-1, true)
end, { desc = "Go to last buffer" })

vim.keymap.set("n", "<leader>bd", ":bdelete<CR>", { desc = "Close current buffer" })
vim.keymap.set("n", "<leader>br", ":BufferLineCloseRight<CR>", { desc = "Close buffers to the right" })
vim.keymap.set("n", "<leader>bl", ":BufferLineCloseLeft<CR>", { desc = "Close buffers to the left" })
vim.keymap.set("n", "<leader>bp", ":BufferLinePick<CR>", { desc = "Pick buffer" })
