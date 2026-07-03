vim.api.nvim_create_autocmd("VimEnter", {
	once = true,
	callback = function()
		local function to_pascal_case(name)
			return name:gsub("-(%l)", string.upper):gsub("^%l", string.upper)
		end

		local function find_lucide_path()
			local npm_root = vim.fn.system("npm root -g 2>nul"):gsub("%s+", "")
			if npm_root ~= "" then
				local p = npm_root .. "/lucide-static"
				if vim.fn.isdirectory(p) == 1 then
					return p
				end
			end
			return nil
		end

		local function build_icon_list(lucide_path)
			local icons = {}
			local svg_files = vim.fn.globpath(lucide_path .. "/icons", "*.svg", false, true)
			if #svg_files == 0 then
				return icons
			end

			local all_names = {}
			local name_set = {}
			for _, f in ipairs(svg_files) do
				local name = vim.fn.fnamemodify(f, ":t:r")
				table.insert(all_names, name)
				name_set[name] = true
			end

			local deprecated = {}
			for _, name in ipairs(all_names) do
				local base = name:match("^(.+)%-circle$")
				if base and name_set["circle-" .. base] then
					deprecated[name] = true
				end
				base = name:match("^(.+)%-square$")
				if base and name_set["square-" .. base] then
					deprecated[name] = true
				end
			end

			for _, name in ipairs(all_names) do
				if not deprecated[name] then
					table.insert(icons, {
						name = name,
						component = to_pascal_case(name),
						svg_path = lucide_path .. "/icons/" .. name .. ".svg",
					})
				end
			end

			table.sort(icons, function(a, b)
				return a.component < b.component
			end)
			return icons
		end

		local function insert_import_and_component(icon)
			local buf = vim.api.nvim_get_current_buf()
			local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)

			local import_stmt = ("import { %s } from 'lucide-react'"):format(icon.component)
			local import_found = false

			for i, line in ipairs(lines) do
				local existing_imports = line:match("^import%s+{(.-)}%s+from%s+['\"]lucide%-react['\"]%s*$")
				if existing_imports then
					import_found = true
					local trimmed = existing_imports:gsub("^%s*(.-)%s*$", "%1")
					if not trimmed:find(vim.pesc(icon.component), 1, true) then
						local new_line = ("import { %s, %s } from 'lucide-react'"):format(trimmed, icon.component)
						vim.api.nvim_buf_set_lines(buf, i - 1, i, false, { new_line })
					end
					break
				end
			end

			if not import_found then
				vim.api.nvim_buf_set_lines(buf, 0, 0, false, { import_stmt, "" })
			end

			local row = vim.api.nvim_win_get_cursor(0)[1]
			local component_line = ("<" .. icon.component .. " size={24} />")
			vim.api.nvim_buf_set_lines(buf, row - 1, row - 1, false, { component_line })
			vim.api.nvim_win_set_cursor(0, { row + 1, 0 })
		end

		local function lucide_picker()
			local lucide_path = find_lucide_path()
			if not lucide_path then
				vim.notify("lucide-static not found. Run: npm install -g lucide-static", vim.log.levels.ERROR)
				return
			end

			local icons = build_icon_list(lucide_path)
			if #icons == 0 then
				vim.notify("No Lucide icons found", vim.log.levels.WARN)
				return
			end

			local pickers = require("telescope.pickers")
			local finders = require("telescope.finders")
			local conf = require("telescope.config").values
			local actions = require("telescope.actions")
			local action_state = require("telescope.actions.state")
			local previewers = require("telescope.previewers")

			local has_chafa = vim.fn.executable("chafa") == 1
			local has_magick = vim.fn.executable("magick") == 1
			local can_preview = has_chafa and has_magick
			local previewer = can_preview and previewers.new_termopen_previewer({
				get_command = function(entry)
					local cmd = ('magick convert "%s" png:- 2>nul | chafa --symbols=block --size=80x20 -')
						:format(entry.value.svg_path)
					return { "cmd", "/c", cmd }
				end,
			}) or previewers.new_buffer_previewer({
				title = "SVG Preview",
				define_preview = function(self, entry)
					local icon = entry.value
					local header_lines = {
						"// Component: " .. icon.component,
						"// Icon:      " .. icon.name,
						"",
					}
					vim.api.nvim_buf_set_lines(self.state.bufnr, 0, -1, false, header_lines)
					if vim.fn.filereadable(icon.svg_path) == 1 then
						local svg_lines = vim.fn.readfile(icon.svg_path)
						vim.api.nvim_buf_set_lines(self.state.bufnr, #header_lines, -1, false, svg_lines)
					end
					vim.api.nvim_set_option_value("filetype", "xml", { buf = self.state.bufnr })
				end,
			})

			pickers
				.new({}, {
					prompt_title = "Lucide Icons",
					finder = finders.new_table({
						results = icons,
						entry_maker = function(icon)
							return {
								value = icon,
								display = icon.component,
								ordinal = icon.component:lower() .. " " .. icon.name,
							}
						end,
					}),
					sorter = conf.generic_sorter({}),
					previewer = previewer,
					attach_mappings = function(prompt_bufnr)
						actions.select_default:replace(function()
							local selection = action_state.get_selected_entry()
							actions.close(prompt_bufnr)
							if not selection then
								return
							end
							insert_import_and_component(selection.value)
						end)
						return true
					end,
				})
				:find()
		end

		vim.keymap.set("n", "<leader>si", lucide_picker, { desc = "Lucide Icons" })
	end,
})
