-- Neo-tree is a Neovim plugin to browse the file system
-- https://github.com/nvim-neo-tree/neo-tree.nvim

return {
  'nvim-neo-tree/neo-tree.nvim',
  version = '*',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-tree/nvim-web-devicons', -- not strictly required, but recommended
    'MunifTanjim/nui.nvim',
    {
      'antosha417/nvim-lsp-file-operations',
      dependencies = { 'nvim-lua/plenary.nvim' },
      config = true,
    },
  },
  lazy = false,
  keys = {
    { '\\', ':Neotree toggle<CR>', desc = 'NeoTree toggle', silent = true },
  },
  opts = {
    filesystem = {
      window = {
        position = 'float',
        float = {
          width = '80%', -- Example: 80% of screen width
          height = '80%', -- Example: 80% of screen height
          position = '50%', -- Example: Center the float
        },
        mappings = {
          ['\\'] = 'close_window',
          ['l'] = 'open', -- open file or expand dir
          ['h'] = 'close_node',
        },
      },
    },
  },
  -- config = function(_, opts)
  --   require('neo-tree').setup(opts)
  --
  --   vim.api.nvim_create_autocmd('BufDelete', {
  --     desc = 'Close NeoTree before deleting a buffer',
  --     callback = function(args)
  --       if vim.bo[args.buf].filetype ~= 'neo-tree' then
  --         vim.cmd 'Neotree close'
  --       end
  --     end,
  --   })
  -- end,
}
