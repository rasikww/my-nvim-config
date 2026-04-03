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
    for i = 1, 9 do
      vim.keymap.set('n', '<leader>' .. i, function()
        require('bufferline').go_to(i, true)
      end, { desc = 'Go to buffer ' .. i })
    end

    -- Optional: map <leader>0 to go to the last buffer
    vim.keymap.set('n', '<leader>0', function()
      require('bufferline').go_to(-1, true)
    end, { desc = 'Go to last buffer' })
  end,
}
