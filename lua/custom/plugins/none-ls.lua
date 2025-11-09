return {
  {
    'nvimtools/none-ls.nvim',
    event = 'VeryLazy',
    dependencies = { 'davidmh/cspell.nvim' },
    opts = function(_, opts)
      local cspell = require 'cspell'
      local null_ls = require 'null-ls'

      -- -- Helper: check if any of these config files exist in root
      -- local function has_root_file(files)
      --   local cwd = vim.fn.getcwd()
      --   for _, file in ipairs(files) do
      --     if vim.fn.filereadable(cwd .. '/' .. file) == 1 then
      --       return true
      --     end
      --   end
      --   return false
      -- end
      --
      opts.sources = opts.sources or {}

      -- CSpell diagnostics and code actions
      table.insert(
        opts.sources,
        cspell.diagnostics.with {
          diagnostics_postprocess = function(diagnostic)
            diagnostic.severity = vim.diagnostic.severity.HINT
          end,
        }
      )
      table.insert(opts.sources, cspell.code_actions)

      -- Conditionally add eslint_d diagnostics & code actions
      -- if has_root_file { '.eslintrc.js', '.eslintrc.json', 'eslint.config.js', 'eslint.config.cjs', 'eslint.config.mjs' } then
      --   table.insert(opts.sources, null_ls.builtins.diagnostics.eslint_d)
      --   table.insert(opts.sources, null_ls.builtins.code_actions.eslint_d)
      -- end
      --
      -- -- Conditionally add prettierd formatter
      -- if
      --   has_root_file {
      --     '.prettierrc',
      --     '.prettierrc.js',
      --     '.prettierrc.json',
      --     'prettier.config.js',
      --     'prettier.config.cjs',
      --   }
      -- then
      --   table.insert(opts.sources, null_ls.builtins.formatting.prettierd)
      -- end
      -- Add this to your config
      -- Add this to your config
      -- Add this to your config
      vim.api.nvim_create_user_command('CSpellAddAll', function()
        local words = {}
        -- Get all diagnostics for the current buffer
        local diagnostics = vim.diagnostic.get(0)

        for _, diagnostic in ipairs(diagnostics) do
          if diagnostic.source == 'cspell' then
            local word = vim.api.nvim_buf_get_text(0, diagnostic.lnum, diagnostic.col, diagnostic.end_lnum, diagnostic.end_col, {})[1]
            if word and word ~= '' then
              words[word] = true
            end
          end
        end

        local count = 0
        local cspell_path = vim.fn.getcwd() .. '/cspell.json'

        -- Check if cspell.json exists
        if vim.fn.filereadable(cspell_path) == 0 then
          print('cspell.json not found at: ' .. cspell_path)
          return
        end

        -- Read and parse cspell.json
        local file = io.open(cspell_path, 'r')
        local content = file:read '*all'
        file:close()

        local config = vim.fn.json_decode(content)
        config.words = config.words or {}

        -- Add new words
        for word, _ in pairs(words) do
          if not vim.tbl_contains(config.words, word) then
            table.insert(config.words, word)
            count = count + 1
          end
        end

        -- Sort words alphabetically
        table.sort(config.words)

        -- Write back to file
        local encoded = vim.fn.json_encode(config)
        file = io.open(cspell_path, 'w')
        file:write(encoded)
        file:close()

        if count > 0 then
          print('Added ' .. count .. ' words to cspell.json')
          vim.cmd 'edit' -- Reload buffer to refresh diagnostics
        else
          print 'No new words to add'
        end
      end, {})
    end,
  },
}
