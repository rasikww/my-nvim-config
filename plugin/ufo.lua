vim.pack.add({
	{ src = "https://github.com/kevinhwang91/promise-async" },
	{ src = "https://github.com/kevinhwang91/nvim-ufo", name = "ufo" },
})

vim.api.nvim_set_hl(0, "MyFoldSuffix", { fg = "#000000", bg = "#ff9e64", bold = true })
local handler = function(virtText, lnum, endLnum, width, truncate)
	local newVirtText = {}
	local suffix = (" 󰁂 %d "):format(endLnum - lnum)
	local sufWidth = vim.fn.strdisplaywidth(suffix)
	local targetWidth = width - sufWidth
	local curWidth = 0
	for _, chunk in ipairs(virtText) do
		local chunkText = chunk[1]
		local chunkWidth = vim.fn.strdisplaywidth(chunkText)
		if targetWidth > curWidth + chunkWidth then
			table.insert(newVirtText, chunk)
		else
			chunkText = truncate(chunkText, targetWidth - curWidth)
			local hlGroup = chunk[2]
			table.insert(newVirtText, { chunkText, hlGroup })
			chunkWidth = vim.fn.strdisplaywidth(chunkText)
			-- str width returned from truncate() may less than 2nd argument, need padding
			if curWidth + chunkWidth < targetWidth then
				suffix = suffix .. (" "):rep(targetWidth - curWidth - chunkWidth)
			end
			break
		end
		curWidth = curWidth + chunkWidth
	end
	table.insert(newVirtText, { suffix, "MyFoldSuffix" })
	return newVirtText
end

require("ufo").setup({
	provider_selector = function(bufnr, filetype, buftype)
		return { "treesitter", "indent" }
	end,
	fold_virt_text_handler = handler,
})

vim.o.foldcolumn = "1" -- '0' is not bad
vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
vim.o.foldlevelstart = 99
vim.o.foldenable = true
vim.opt.fillchars = {
	foldopen = " ",
	foldclose = "▶",
	fold = " ",
	foldsep = " ",
	foldinner = " ", --not available in neovim yet?
	--TODO: check if foldinner is available on neovim,
}

-- zS: Toggle Signatures View (fold function bodies, keep signatures visible)
vim.keymap.set("n", "zS", function()
	local bufnr = vim.api.nvim_get_current_buf()

	-- 1. TOGGLE OFF: Restore previous foldmethod
	if vim.b.zS_signatures_view then
		if vim.b.zS_saved_foldmethod then
			vim.wo.foldmethod = vim.b.zS_saved_foldmethod
		end
		vim.cmd("normal! zR") -- Open all folds
		vim.b.zS_signatures_view = nil
		vim.b.zS_saved_foldmethod = nil
		return
	end

	-- 2. VALIDATE TREESITTER
	local parser = vim.treesitter.get_parser(bufnr)
	if not parser then
		vim.notify("zS: No treesitter parser for " .. vim.bo[bufnr].filetype, vim.log.levels.WARN)
		return
	end

	local ft = vim.bo[bufnr].filetype
	local ts_lang = parser:lang() -- Safer way to get the true TS language

	-- Expanded Query Map (Matches the exact nodes containing bodies)
	local query_map = {
		typescript = [[
			(function_declaration) @func
			(function_expression) @func
			(method_definition) @func
			(arrow_function) @func
			(ambient_declaration) @func
		]],
		javascript = [[
			(function_declaration) @func
			(function_expression) @func
			(generator_function_declaration) @func
			(generator_function_expression) @func
			(method_definition) @func
			(arrow_function) @func
		]],
		lua = [[
			(function_definition) @func
			(function_declaration) @func
		]],
		python = [[
			(function_definition) @func
			(async_function_definition) @func
		]],
	}

	local query_str = query_map[ft] or query_map[ts_lang]
	if not query_str then
		-- Fallback pattern matching for sub-types (like typescriptreact)
		for lang, qs in pairs(query_map) do
			if ft:find("^" .. lang) then
				query_str = qs
				break
			end
		end
	end

	if not query_str then
		vim.notify("zS: Unsupported filetype " .. ft, vim.log.levels.WARN)
		return
	end

	local ok, query = pcall(vim.treesitter.query.parse, ts_lang, query_str)
	if not ok then
		vim.notify("zS: Query parse failed for " .. ft, vim.log.levels.WARN)
		return
	end

	-- 3. SETUP FOLD ENVIRONMENT
	-- Save window-scoped foldmethod (foldmethod is technically window-local)
	vim.b.zS_saved_foldmethod = vim.wo.foldmethod
	vim.wo.foldmethod = "manual"
	vim.cmd("normal! zE") -- Delete all existing folds

	local tree = parser:parse()[1]
	local root = tree:root()

	-- 4. COLLECT AND SORT FOLDS (To handle nesting gracefully)
	local folds = {}
	for _, node, _ in query:iter_captures(root, bufnr, 0, -1) do
		-- Look specifically for the body block of the function where possible
		-- to dynamically figure out where the signature ends.
		local body_node = node:field("body")[1] or node:child(node:child_count() - 1)

		if body_node then
			local start_row, _, end_row, _ = body_node:range()

			-- Convert 0-indexed API rows to 1-indexed Vim lines
			local fold_start = start_row + 1
			local fold_end = end_row + 1

			-- Adjustments: If it's a braced block `{ ... }`, fold inside the braces
			if body_node:type() == "block" or body_node:type() == "statement_block" then
				fold_start = fold_start + 1
				fold_end = fold_end - 1
			end

			if fold_end >= fold_start then
				table.insert(folds, { start = fold_start, finish = fold_end })
			end
		end
	end

	-- Sort folds from bottom of the file to top.
	-- This prevents nested inner folds from messing up outer fold indices.
	table.sort(folds, function(a, b)
		return a.start > b.start
	end)

	-- 5. APPLY FOLDS
	for _, f in ipairs(folds) do
		pcall(function()
			vim.cmd(string.format("%d,%dfold", f.start, f.finish))
		end)
	end

	vim.b.zS_signatures_view = true
end, { desc = "Toggle [S]ignatures view (fold function bodies)" })
