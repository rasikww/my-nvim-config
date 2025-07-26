return {
  'pmizio/typescript-tools.nvim',
  dependencies = { 'nvim-lua/plenary.nvim', 'neovim/nvim-lspconfig' },
  opts = {},
  config = function()
    require('typescript-tools').setup {
      -- tsserver_path = 'C:/Users/willo/AppData/Roaming/npm/node_modules/typescript-language-server',
      settings = {
        tsserver_plugins = {},
        separate_diagnostic_server = true,
        expose_as_code_action = 'all',
      },
    }
  end,
}
