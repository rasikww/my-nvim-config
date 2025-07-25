return {
  'akinsho/bufferline.nvim',
  version = '*',
  dependencies = 'nvim-tree/nvim-web-devicons',
  config = function()
    require('bufferline').setup {
      options = {
        mode = 'buffers',
        style_preset = require('bufferline').style_preset.default,
        themable = true,
        numbers = 'ordinal',
        close_command = 'bdelete! %d',
        indicator = {
          icon = '▎',
          style = 'icon',
        },
        separator_style = 'slant',
        always_show_bufferline = true,
        diagnostics = 'nvim_lsp',
        diagnostics_update_on_event = true, -- use nvim's diagnostic handler
        offsets = {
          {
            filetype = 'neo-tree',
            text = 'File Explorer',
            text_align = 'left',
            separator = true,
          },
        },
      },
    }
  end,
}
