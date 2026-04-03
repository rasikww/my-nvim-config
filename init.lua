vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Disable default normal-mode behavior of space
vim.keymap.set("n", "<Space>", "<Nop>", { silent = true })
vim.keymap.set("v", "<Space>", "<Nop>", { silent = true })

local env_file = vim.fn.stdpath("config") .. "/.env"

if vim.fn.filereadable(env_file) == 1 then
	for _, line in ipairs(vim.fn.readfile(env_file)) do
		local key, value = line:match("^([^=]+)=(.+)$")
		if key and value then
			vim.env[key] = value
		end
	end
end
-- Set to true if you have a Nerd Font installed and selected in the terminal
vim.g.have_nerd_font = true

-- [[ Setting options ]]
-- See `:help vim.o`
-- NOTE: You can change these options as you wish!
--  For more options, you can see `:help option-list`

-- Make line numbers default
vim.o.number = true
-- You can also add relative line numbers, to help with jumping.
vim.o.relativenumber = true

-- Enable mouse mode, can be useful for resizing splits for example!
vim.o.mouse = "a"

-- Don't show the mode, since it's already in the status line
vim.o.showmode = false

-- Sync clipboard between OS and Neovim.
vim.api.nvim_create_autocmd("UIEnter", {
	once = true,
	callback = function()
		vim.defer_fn(function()
			vim.o.clipboard = "unnamedplus"
		end, 100)
	end,
})

-- Enable break indent
vim.o.breakindent = true

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.smartindent = true
vim.o.autoindent = true
vim.o.swapfile = false
vim.opt.termguicolors = true
-- Keep signcolumn on by default
vim.o.signcolumn = "yes"

-- Decrease update time
vim.o.updatetime = 250

-- Decrease mapped sequence wait time
vim.o.timeoutlen = 300

-- Configure how new splits should be opened
vim.o.splitright = true
vim.o.splitbelow = true

-- Sets how neovim will display certain whitespace characters in the editor.
--  See `:help 'list'`
--  and `:help 'listchars'`
--
--  Notice listchars is set using `vim.opt` instead of `vim.o`.
--  It is very similar to `vim.o` but offers an interface for conveniently interacting with tables.
--   See `:help lua-options`
--   and `:help lua-options-guide`
vim.o.list = false
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }

-- Preview substitutions live, as you type!
vim.o.inccommand = "split"

-- Show which line your cursor is on
vim.o.cursorline = true

-- Minimal number of screen lines to keep above and below the cursor.
vim.o.scrolloff = 10

-- if performing an operation that would fail due to unsaved changes in the buffer (like `:q`),
-- instead raise a dialog asking if you wish to save the current file(s)
-- See `:help 'confirm'`
vim.o.confirm = true

-- [[ Basic Builtin plugins  ]]
-- vim.cmd('packadd nvim.undotree')

-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`

-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- Diagnostic keymaps
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic [Q]uickfix list" })

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- TIP: Disable arrow keys in normal mode
-- vim.keymap.set('n', '<left>', '<cmd>echo "Use h to move!!"<CR>')
-- vim.keymap.set('n', '<right>', '<cmd>echo "Use l to move!!"<CR>')
-- vim.keymap.set('n', '<up>', '<cmd>echo "Use k to move!!"<CR>')
-- vim.keymap.set('n', '<down>', '<cmd>echo "Use j to move!!"<CR>')

-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
--
--  See `:help wincmd` for a list of all window commands
vim.keymap.set("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
vim.keymap.set("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
vim.keymap.set("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
vim.keymap.set("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })

-- NOTE: Some terminals have colliding keymaps or are not able to send distinct keycodes
-- vim.keymap.set("n", "<C-S-h>", "<C-w>H", { desc = "Move window to the left" })
-- vim.keymap.set("n", "<C-S-l>", "<C-w>L", { desc = "Move window to the right" })
-- vim.keymap.set("n", "<C-S-j>", "<C-w>J", { desc = "Move window to the lower" })
-- vim.keymap.set("n", "<C-S-k>", "<C-w>K", { desc = "Move window to the upper" })

-- My key maps
vim.keymap.set("n", "<S-Tab>", "<C-^>", { desc = "Toggle last buffer" })
vim.keymap.set("i", "jj", "<Esc>", { noremap = true, silent = true })
vim.keymap.set("i", "kk", "<Esc>", { noremap = true, silent = true })
vim.keymap.set("n", "x", '"_x') -- Don't copy when deleting a character
vim.keymap.set("n", "d", '"_d') -- Don't copy when deleting
vim.keymap.set("v", "d", '"_d') -- Don't copy when deleting
vim.keymap.set("n", "D", '"_D') -- Don't copy when deleting
vim.keymap.set("v", "D", '"_D') -- Don't copy when deleting

vim.o.undofile = true
vim.o.undodir = vim.fn.stdpath("state") .. "/undodir"
vim.fn.mkdir(vim.o.undodir, "p") -- create dir if it doesn't exist

-- Tab and indentation settings
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true

vim.opt.wrap = true

-- tailwindclass sort on save
-- no need to run this prettier sorts it better
-- vim.api.nvim_create_autocmd('BufWritePre', {
--   pattern = { '*.tsx', '*.jsx', '*.ts', '*.js' },
--   callback = function()
--     vim.cmd 'TailwindSort'
--   end,
-- })

-- wrap selection with characters
vim.api.nvim_create_user_command("Wrap", function()
	local chars = vim.fn.input('Enter surrounding chars (e.g., "", [], {}, ({})): ')

	local open, close

	if #chars == 2 then
		open = chars:sub(1, 1)
		close = chars:sub(2, 2)
	elseif #chars == 4 then
		open = chars:sub(1, 2)
		close = chars:sub(3, 4)
	else
		vim.notify('Please enter either 2 or 4 characters (e.g., "", [], ({}))', vim.log.levels.WARN)
		return
	end

	local mode = vim.fn.visualmode()

	local start_pos = vim.api.nvim_buf_get_mark(0, "<")
	local end_pos = vim.api.nvim_buf_get_mark(0, ">")

	local start_line = start_pos[1] - 1
	local end_line = end_pos[1] - 1

	local start_col, end_col

	if mode == "V" then
		start_col = 0
		end_col = #vim.api.nvim_buf_get_lines(0, end_line, end_line + 1, false)[1]
	else
		start_col = start_pos[2]
		end_col = end_pos[2] + 1
	end

	local lines = vim.api.nvim_buf_get_text(0, start_line, start_col, end_line, end_col, {})

	if #lines == 0 then
		return
	end

	-- Wrap
	lines[1] = open .. lines[1]
	lines[#lines] = lines[#lines] .. close

	vim.api.nvim_buf_set_text(0, start_line, start_col, end_line, end_col, lines)
end, { range = true })

vim.keymap.set("v", "<leader>w", ":Wrap<CR>", { silent = true, desc = "[W]rap selection" })

-- Visual line at 80 characters
vim.opt.colorcolumn = "80"

-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.hl.on_yank()`
vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
	callback = function()
		vim.hl.on_yank()
	end,
})

-- Function to get visual selection text
local function get_visual_selection()
	local _, csrow, cscol, _ = unpack(vim.fn.getpos("'<"))
	local _, cerow, cecol, _ = unpack(vim.fn.getpos("'>"))

	if csrow == cerow then
		return vim.fn.getline(csrow):sub(cscol, cecol)
	end

	local lines = vim.fn.getline(csrow, cerow)
	lines[1] = lines[1]:sub(cscol)
	lines[#lines] = lines[#lines]:sub(1, cecol)
	return table.concat(lines, "\n")
end

-- Define a command to insert console.log of visual selection
vim.api.nvim_create_user_command("InsertConsoleLogVisual", function()
	local selected = get_visual_selection()
	if selected == "" then
		vim.notify("No selection detected", vim.log.levels.WARN)
		return
	end
	local log_line = "console.log('" .. selected .. ":', " .. selected .. ");"
	local row = vim.api.nvim_win_get_cursor(0)[1]
	vim.api.nvim_buf_set_lines(0, row, row, false, { log_line })
end, {})

-- Define a command to insert print() of visual selection
vim.api.nvim_create_user_command("InsertPrintVisual", function()
	local selected = get_visual_selection()
	if selected == "" then
		vim.notify("No selection detected", vim.log.levels.WARN)
		return
	end
	local log_line = "print('" .. selected .. ":', " .. selected .. ");"
	local row = vim.api.nvim_win_get_cursor(0)[1]
	vim.api.nvim_buf_set_lines(0, row, row, false, { log_line })
end, {})

-- Keymap for visual mode to insert log
vim.keymap.set("v", "<leader>ll", ":<C-u>InsertConsoleLogVisual<CR>", { desc = "Log selected text", silent = true })

-- Keymap for visual mode to insert print
vim.keymap.set("v", "<leader>lp", ":<C-u>InsertPrintVisual<CR>", { desc = "Print selected text", silent = true })

--keymap to save in edit mode
vim.keymap.set("i", "<C-s>", "<Esc>:w<CR>", { desc = "Save file", silent = true })
vim.keymap.set("n", "<C-s>", "<Esc>:w<CR>", { desc = "Save file", silent = true })
vim.keymap.set("v", "<C-s>", "<Esc>:w<CR>", { desc = "Save file", silent = true })

-- Move in insert mode with Alt + hjkl
vim.keymap.set("i", "<A-h>", "<Left>", { noremap = true, silent = true })
vim.keymap.set("i", "<A-j>", "<Down>", { noremap = true, silent = true })
vim.keymap.set("i", "<A-k>", "<Up>", { noremap = true, silent = true })
vim.keymap.set("i", "<A-l>", "<Right>", { noremap = true, silent = true })

--keymap to quickly navigate to front and back
vim.keymap.set("n", "H", "^", { noremap = true, silent = true })
vim.keymap.set("n", "L", "$", { noremap = true, silent = true })
vim.keymap.set("v", "H", "^", { noremap = true, silent = true })
vim.keymap.set("v", "L", "$", { noremap = true, silent = true })

-- File format save as LF
vim.opt.fileformats = { "unix", "dos" }
vim.opt.fileformat = "unix"

-- borders
vim.o.winborder = "rounded"

-- Quickfix and Location list mappings
--[[ vim.api.nvim_create_autocmd('FileType', {
  pattern = 'qf',
  callback = function()
    local opts = { buffer = true, silent = true }

    -- Check if it's a location list or quickfix list
    local is_loclist = vim.fn.getloclist(0, { filewinid = 1 }).filewinid ~= 0

    -- Enter: go to location and close list
    vim.keymap.set('n', '<CR>', function()
      local line = vim.fn.line '.'
      if is_loclist then
        vim.cmd(line .. 'll') -- jump to location list item
        vim.cmd 'lclose'
      else
        vim.cmd(line .. 'cc') -- jump to quickfix item
        vim.cmd 'cclose'
      end
    end, opts)
  end,
}) ]]

--get default branch
local function get_default_branch()
	local default_branch = nil
	-- Try symbolic-ref first (silence errors)
	local ok, result = pcall(vim.fn.systemlist, "git symbolic-ref --quiet refs/remotes/origin/HEAD")

	if ok and result and result[1] and result[1] ~= "" then
		default_branch = result[1]:gsub("refs/remotes/origin/", "")
	end

	-- Fallback: parse remote show origin
	if not default_branch then
		local remote_info = vim.fn.systemlist("git remote show origin")
		for _, line in ipairs(remote_info) do
			local match = line:match("HEAD branch: (.+)")
			if match then
				default_branch = match
				break
			end
		end
	end

	-- Final fallback
	if not default_branch or default_branch == "" then
		default_branch = "main"
	end

	return default_branch
end

--get list of changed files in the current branch compared to main
vim.keymap.set("n", "<leader>pf", function()
	local notify = vim.notify

	local loading_id = notify("Loading changed files in the branch…", vim.log.levels.INFO, {
		title = "Git Diff",
		timeout = false,
	})

	local default_branch = nil

	-- Try symbolic-ref first (silence errors)
	local ok, result = pcall(vim.fn.systemlist, "git symbolic-ref --quiet refs/remotes/origin/HEAD")

	if ok and result and result[1] and result[1] ~= "" then
		default_branch = result[1]:gsub("refs/remotes/origin/", "")
	end

	-- Fallback: parse remote show origin
	if not default_branch then
		local remote_info = vim.fn.systemlist("git remote show origin")
		for _, line in ipairs(remote_info) do
			local match = line:match("HEAD branch: (.+)")
			if match then
				default_branch = match
				break
			end
		end
	end

	-- Final fallback
	if not default_branch or default_branch == "" then
		default_branch = "main"
	end

	require("telescope.pickers")
		.new({}, {
			prompt_title = "Changed Files (vs " .. default_branch .. ")",
			finder = require("telescope.finders").new_oneshot_job({
				"git",
				"diff",
				"--name-only",
				"origin/" .. default_branch .. "...HEAD",
			}, {
				on_exit = function()
					vim.schedule(function()
						notify("Files loaded ✔", vim.log.levels.INFO, {
							title = "Git Diff",
							replace = loading_id,
							timeout = 800,
						})
					end)
				end,
			}),
			previewer = require("telescope.config").values.file_previewer({}),
			sorter = require("telescope.config").values.generic_sorter({}),
		})
		:find()
end, { desc = "[P]roject [F]iles changed from default branch" })

-- get list of changed files in the current branch compared to user selected branch
vim.keymap.set("n", "<leader>pc", function()
	local pickers = require("telescope.pickers")
	local finders = require("telescope.finders")
	local conf = require("telescope.config").values
	local actions = require("telescope.actions")
	local action_state = require("telescope.actions.state")
	local notify = vim.notify

	-- Step 1: Open Branch Picker
	require("telescope.builtin").git_branches({
		prompt_title = "Select Branch to Diff Against",
		attach_mappings = function(prompt_bufnr, map)
			actions.select_default:replace(function()
				-- Get the selected branch name
				local selection = action_state.get_selected_entry()
				actions.close(prompt_bufnr)

				if not selection then
					return
				end

				-- The branch name (handles both local and remote)
				local target_branch = selection.value

				-- Step 2: Show loading notification
				local loading_id = notify("Diffing against " .. target_branch .. "...", vim.log.levels.INFO, {
					title = "Git Diff",
					timeout = false,
				})

				-- Step 3: Launch the file picker for changed files
				pickers
					.new({}, {
						prompt_title = "Files changed vs " .. target_branch,
						finder = finders.new_oneshot_job({
							"git",
							"diff",
							"--name-only",
							target_branch .. "...HEAD",
						}, {
							on_exit = function()
								vim.schedule(function()
									notify("Files loaded ✔", vim.log.levels.INFO, {
										title = "Git Diff",
										replace = loading_id,
										timeout = 800,
									})
								end)
							end,
						}),
						previewer = conf.file_previewer({}),
						sorter = conf.generic_sorter({}),
					})
					:find()
			end)
			return true
		end,
	})
end, { desc = "[P]roject [C]hoose branch to diff" })

vim.keymap.set("n", "<leader>pa", function()
	local pickers = require("telescope.pickers")
	local finders = require("telescope.finders")
	local conf = require("telescope.config").values
	local actions = require("telescope.actions")
	local action_state = require("telescope.actions.state")
	local notify = vim.notify

	-- Helper: get commit hashes for a branch (no merges)
	local function get_commits(branch)
		local result = vim.fn.systemlist('git log --no-merges --format="%H" ' .. branch)
		local set = {}
		for _, hash in ipairs(result) do
			hash = hash:gsub('"', "")
			if hash ~= "" then
				set[hash] = true
			end
		end
		return set
	end

	-- Helper: get files changed by a set of commits
	local function get_files_from_commits(commit_set)
		local files = {}
		local seen = {}
		for hash, _ in pairs(commit_set) do
			local changed = vim.fn.systemlist("git diff-tree --no-commit-id -r --name-only " .. hash)
			for _, file in ipairs(changed) do
				if not seen[file] then
					seen[file] = true
					table.insert(files, file)
				end
			end
		end
		table.sort(files)
		return files
	end

	-- Helper: subtract commits of branch_a and branch_b from current branch commits
	local function subtract_commits(current_commits, branch_a_commits, branch_b_commits)
		local result = {}
		for hash, _ in pairs(current_commits) do
			if not branch_a_commits[hash] and not branch_b_commits[hash] then
				result[hash] = true
			end
		end
		return result
	end

	-- Step 1: Get current branch name
	local current_branch = vim.fn.system("git branch --show-current"):gsub("\n", "")

	if current_branch == "" then
		notify("Not on a git branch", vim.log.levels.ERROR, { title = "Git Diff" })
		return
	end

	-- Step 2: Pick first branch to exclude
	require("telescope.builtin").git_branches({
		prompt_title = "Select First Branch to Exclude (e.g. main)",
		attach_mappings = function(prompt_bufnr_a)
			actions.select_default:replace(function()
				local selection_a = action_state.get_selected_entry()
				actions.close(prompt_bufnr_a)
				if not selection_a then
					return
				end

				local branch_a = selection_a.value

				-- Step 3: Pick second branch to exclude
				require("telescope.builtin").git_branches({
					prompt_title = "Select Second Branch to Exclude (e.g. INT-144)",
					attach_mappings = function(prompt_bufnr_b)
						actions.select_default:replace(function()
							local selection_b = action_state.get_selected_entry()
							actions.close(prompt_bufnr_b)
							if not selection_b then
								return
							end

							local branch_b = selection_b.value

							-- Step 4: Loading notification
							local loading_id = notify(
								"Calculating your commits vs " .. branch_a .. " and " .. branch_b .. "...",
								vim.log.levels.INFO,
								{ title = "Git Diff", timeout = false }
							)

							-- Step 5: Get commits for each branch
							local current_commits = get_commits(current_branch)
							local branch_a_commits = get_commits(branch_a)
							local branch_b_commits = get_commits(branch_b)

							-- Step 6: Subtract branch A and B commits from current branch commits
							local exclusive_commits =
								subtract_commits(current_commits, branch_a_commits, branch_b_commits)

							if vim.tbl_isempty(exclusive_commits) then
								notify("No exclusive commits found in " .. current_branch, vim.log.levels.WARN, {
									title = "Git Diff",
									replace = loading_id,
									timeout = 3000,
								})
								return
							end

							-- Step 7: Get files from exclusive commits
							local files = get_files_from_commits(exclusive_commits)

							if #files == 0 then
								notify("No changed files found in exclusive commits", vim.log.levels.WARN, {
									title = "Git Diff",
									replace = loading_id,
									timeout = 3000,
								})
								return
							end

							-- Step 8: Show file picker
							notify("Found " .. #files .. " files ✔", vim.log.levels.INFO, {
								title = "Git Diff",
								replace = loading_id,
								timeout = 800,
							})

							pickers
								.new({}, {
									prompt_title = "Your files in "
										.. current_branch
										.. " ("
										.. #files
										.. " files, excl. "
										.. branch_a
										.. " & "
										.. branch_b
										.. ")",
									finder = finders.new_table({
										results = files,
									}),
									previewer = conf.file_previewer({}),
									sorter = conf.generic_sorter({}),
								})
								:find()
						end)
						return true
					end,
				})
			end)
			return true
		end,
	})
end, { desc = "[P]roject [A]ll files changed exclusively in current branch" })
