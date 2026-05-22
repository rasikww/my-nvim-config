vim.api.nvim_create_autocmd("VimEnter", {
	once = true,
	callback = function()
		vim.pack.add({
			{ src = "https://github.com/nvim-lua/plenary.nvim" },
			{ src = "https://github.com/nvim-telescope/telescope-fzf-native.nvim", build = "make" },
			{ src = "https://github.com/nvim-telescope/telescope-ui-select.nvim" },
			{ src = "https://github.com/nvim-tree/nvim-web-devicons", enabled = vim.g.have_nerd_font },
			{ src = "https://github.com/debugloop/telescope-undo.nvim" },
			{ src = "https://github.com/nvim-telescope/telescope.nvim" },
		})

		local actions = require("telescope.actions")
		local action_state = require("telescope.actions.state")
		local custom_enter_function = function(prompt_bufnr)
			local entry = require("telescope.actions.state").get_selected_entry()
			require("telescope.actions").close(prompt_bufnr)

			if not entry or not (entry.path or entry.filename) then
				print("Invalid file entry")
				return
			end

			local raw_path = entry.path or entry.filename
			local fixed_path = raw_path:gsub("\\", "/")
			local escaped_path = vim.fn.fnameescape(fixed_path)

			-- Get line and column if available (for live_grep / grep_string)
			local lnum = entry.lnum or entry.line
			local col = entry.col

			if lnum then
				-- jump to specific line (and column if available)
				vim.cmd(string.format("edit +%d %s", lnum, escaped_path))
				if col then
					vim.schedule(function()
						vim.fn.cursor(lnum, col)
					end)
				end
			else
				-- regular open
				vim.cmd("edit " .. escaped_path)
			end
		end

		require("telescope").setup({
			-- You can put your default mappings / updates / etc. in here
			--  All the info you're looking for is in `:help telescope.setup()`
			--
			defaults = {
				layout_strategy = "vertical",
				layout_config = {
					prompt_position = "bottom", -- prompt at the bottom
					width = 0.95,
					height = 0.95,
					preview_cutoff = 1, -- always show preview (important)
					vertical = {
						width = 0.95,
						height = 0.95,
						preview_height = 0.5, -- preview takes top half
					},
				},
				mappings = {
					n = {
						["d"] = require("telescope.actions").delete_buffer,
					}, -- n
					i = {
						["<c-d>"] = require("telescope.actions").delete_buffer,

						["<C-j>"] = actions.preview_scrolling_down,
						["<C-k>"] = actions.preview_scrolling_up,
						["<C-h>"] = actions.preview_scrolling_left,
						["<C-l>"] = actions.preview_scrolling_right,
					}, -- i = { ['<c-enter>'] = 'to_fuzzy_refine' },
				},
			},
			-- pickers = {}
			pickers = {
				find_files = {
					mappings = {
						i = {
							["<CR>"] = custom_enter_function,
							["<C-y>"] = custom_enter_function,
						},
						n = {
							["<CR>"] = custom_enter_function,
							["<C-y>"] = custom_enter_function,
						},
					},
					find_command = {
						"rg",
						"--files",
						"--hidden",
						"--glob",
						"!.git/",
						"--path-separator",
						"/",
					},
				},
				oldfiles = {
					mappings = {
						i = {
							["<CR>"] = custom_enter_function,
							["<C-y>"] = custom_enter_function,
						},
						n = {
							["<CR>"] = custom_enter_function,
							["<C-y>"] = custom_enter_function,
						},
					},
				},
				search_history = {
					mappings = {
						i = {
							["<CR>"] = custom_enter_function,
							["<C-y>"] = custom_enter_function,
						},
						n = {
							["<CR>"] = custom_enter_function,
							["<C-y>"] = custom_enter_function,
						},
					},
				},
				live_grep = {
					mappings = {
						i = {
							["<CR>"] = custom_enter_function,
							["<C-y>"] = custom_enter_function,
						},
						n = {
							["<CR>"] = custom_enter_function,
							["<C-y>"] = custom_enter_function,
						},
					},
				},
				lsp_references = {
					mappings = {
						i = {
							["<CR>"] = custom_enter_function,
						},
						n = {
							["<CR>"] = custom_enter_function,
							["<C-y>"] = custom_enter_function,
						},
					},
				},
				lsp_definitions = {
					mappings = {
						i = {
							["<CR>"] = custom_enter_function,
						},
						n = {
							["<CR>"] = custom_enter_function,
							["<C-y>"] = custom_enter_function,
						},
					},
				},
				lsp_implementations = {
					mappings = {
						i = {
							["<CR>"] = custom_enter_function,
						},
						n = {
							["<CR>"] = custom_enter_function,
							["<C-y>"] = custom_enter_function,
						},
					},
				},
			},
			extensions = {
				["ui-select"] = {
					require("telescope.themes").get_dropdown(),
				},
				undo = {
					use_delta = true,
					use_custom_command = nil, -- setting this implies `use_delta = false`. Accepted format is: { "bash", "-c", "echo '$DIFF' | delta" }
					side_by_side = true,
					vim_diff_opts = {
						ctxlen = vim.o.scrolloff,
					},
					entry_format = "state #$ID, $STAT, $TIME",
					time_format = "%Y-%m-%d %H:%M:%S",
					saved_only = false, -- telescope-undo.nvim config, see below
				},
			},
		})

		-- Enable Telescope extensions if they are installed
		pcall(require("telescope").load_extension, "fzf")
		pcall(require("telescope").load_extension, "ui-select")
		require("telescope").load_extension("undo")

		-- See `:help telescope.builtin`
		local builtin = require("telescope.builtin")
		vim.keymap.set("n", "<leader>sh", builtin.help_tags, { desc = "[S]earch [H]elp" })
		vim.keymap.set("n", "<leader>sk", builtin.keymaps, { desc = "[S]earch [K]eymaps" })
		vim.keymap.set("n", "<leader>sf", builtin.find_files, { desc = "[S]earch [F]iles" })
		vim.keymap.set("n", "<leader>ss", builtin.builtin, { desc = "[S]earch [S]elect Telescope" })
		vim.keymap.set("n", "<leader>sw", builtin.grep_string, { desc = "[S]earch current [W]ord" })
		vim.keymap.set("n", "<leader>sg", builtin.live_grep, { desc = "[S]earch by [G]rep" })
		vim.keymap.set("n", "<leader>sd", builtin.diagnostics, { desc = "[S]earch [D]iagnostics" })
		vim.keymap.set("n", "<leader>sr", builtin.resume, { desc = "[S]earch [R]esume" })
		vim.keymap.set("n", "<leader>s.", builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
		vim.keymap.set("n", "<leader><leader>", builtin.buffers, { desc = "[ ] Find existing buffers" })
		vim.keymap.set("n", "<leader>u", "<cmd>Telescope undo<cr>")

		-- Slightly advanced example of overriding default behavior and theme
		vim.keymap.set("n", "<leader>/", function()
			-- You can pass additional configuration to Telescope to change the theme, layout, etc.
			builtin.current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
				winblend = 10,
				previewer = false,
			}))
		end, { desc = "[/] Fuzzily search in current buffer" })

		-- It's also possible to pass additional configuration options.
		--  See `:help telescope.builtin.live_grep()` for information about particular keys
		vim.keymap.set("n", "<leader>s/", function()
			builtin.live_grep({
				grep_open_files = true,
				prompt_title = "Live Grep in Open Files",
			})
		end, { desc = "[S]earch [/] in Open Files" })

		-- Shortcut for searching your Neovim configuration files
		vim.keymap.set("n", "<leader>sn", function()
			builtin.find_files({ cwd = vim.fn.stdpath("config") })
		end, { desc = "[S]earch [N]eovim files" })
	end,
})

local function telescope_file_history()
	local ok, pickers = pcall(require, "telescope.pickers")
	if not ok then
		vim.notify("Telescope is not fully loaded yet", vim.log.levels.ERROR)
		return
	end

	local finders = require("telescope.finders")
	local conf = require("telescope.config").values
	local actions = require("telescope.actions")
	local action_state = require("telescope.actions.state")

	local current_file = vim.api.nvim_buf_get_name(0)
	if current_file == "" then
		vim.notify("No file active in current buffer", vim.log.levels.WARN)
		return
	end

	-- Use vim.fn.systemlist to grab the log cleanly as an array of lines
	-- We wrap the path in quotes to ensure Windows spaces don't break the shell argument
	local cmd_str = string.format('git log --pretty=format:"%%h - %%s" --follow -- "%s"', current_file)
	local results = vim.fn.systemlist(cmd_str)

	-- Check if git actually returned anything or threw an error
	if vim.v.shell_error ~= 0 or #results == 0 then
		vim.notify("Failed to get git log for this file", vim.log.levels.WARN)
		return
	end

	pickers
		.new({}, {
			prompt_title = "File History (" .. vim.fs.basename(current_file) .. ")",
			-- Fed into a static table instead of an async job stream
			finder = finders.new_table({
				results = results,
			}),
			sorter = conf.generic_sorter({}),
			attach_mappings = function(prompt_bufnr, map)
				actions.select_default:replace(function()
					local selection = action_state.get_selected_entry()
					actions.close(prompt_bufnr)

					if selection and selection[1] then
						local commit_hash = string.match(selection[1], "^(%w+)")
						if commit_hash then
							require("gitsigns").diffthis(commit_hash)
						end
					end
				end)
				return true
			end,
		})
		:find()
end

vim.keymap.set("n", "<leader>gfh", telescope_file_history, { desc = "Telescope File History Diff" })
