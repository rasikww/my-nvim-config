return {
  {
    'akinsho/flutter-tools.nvim',
    lazy = false,
    dependencies = {
      'nvim-lua/plenary.nvim',
      'stevearc/dressing.nvim', -- Optional: for better UI selectors
    },
    config = function()
      require('flutter-tools').setup {
        -- This plugin automatically sets up 'dartls' for you.
        -- Do NOT configure 'dartls' manually in nvim-lspconfig.
        lsp = {
          color = {
            enabled = false, -- Show color previews for colors
          },
          settings = {
            showTodos = true,
            completeFunctionCalls = true,
          },
        },
      }
    end,
  },
}
