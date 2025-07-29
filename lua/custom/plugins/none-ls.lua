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
    end,
  },
}
