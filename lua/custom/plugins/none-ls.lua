return {
  {
    'nvimtools/none-ls.nvim',
    event = 'VeryLazy',
    dependencies = { 'davidmh/cspell.nvim' },
    opts = function(_, opts)
      local cspell = require 'cspell'
      opts.sources = opts.sources or {}

      -- Shared config for both sources
      local cspell_config = {
        config_file_preferred_name = 'cspell.json',
        on_add_to_json = function(payload)
          vim.defer_fn(function()
            vim.cmd 'checktime'
          end, 100)
        end,
      }

      table.insert(
        opts.sources,
        cspell.diagnostics.with {
          diagnostics_postprocess = function(diagnostic)
            diagnostic.severity = vim.diagnostic.severity.HINT
          end,
          config = cspell_config,
        }
      )

      table.insert(
        opts.sources,
        cspell.code_actions.with {
          config = cspell_config,
        }
      )

      -- CSpellAddAll command
      vim.api.nvim_create_user_command('CSpellAddAll', function()
        local words = {}
        local diagnostics = vim.diagnostic.get(0)

        for _, diagnostic in ipairs(diagnostics) do
          if diagnostic.source == 'cspell' then
            local word = vim.api.nvim_buf_get_text(0, diagnostic.lnum, diagnostic.col, diagnostic.end_lnum, diagnostic.end_col, {})[1]
            if word and word ~= '' then
              words[word] = true
            end
          end
        end

        local cspell_path = vim.fn.getcwd() .. '/cspell.json'

        if vim.fn.filereadable(cspell_path) == 0 then
          print('cspell.json not found at: ' .. cspell_path)
          return
        end

        local file = io.open(cspell_path, 'r')
        local content = file:read '*all'
        file:close()

        local config = vim.fn.json_decode(content)
        config.words = config.words or {}

        local existing_words = {}
        for _, word in ipairs(config.words) do
          existing_words[word] = true
        end

        local count = 0
        for word, _ in pairs(words) do
          if not existing_words[word] then
            table.insert(config.words, word)
            count = count + 1
          end
        end

        if count == 0 then
          print 'No new words to add'
          return
        end

        table.sort(config.words)

        local json_content = string.format(
          '{"version":"%s","language":"%s","words":%s,"flagWords":%s}',
          config.version or '0.2',
          config.language or 'en',
          vim.fn.json_encode(config.words),
          vim.fn.json_encode(config.flagWords or {})
        )

        file = io.open(cspell_path, 'w')
        file:write(json_content .. '\n')
        file:close()

        print('Added ' .. count .. ' words to cspell.json')

        vim.defer_fn(function()
          vim.cmd 'checktime'
          vim.diagnostic.reset()
          vim.cmd 'edit'
        end, 100)
      end, {})
    end,
  },
}
