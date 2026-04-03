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
