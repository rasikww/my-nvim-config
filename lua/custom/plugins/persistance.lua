return {
  'folke/persistence.nvim',
  event = 'VimEnter',
  config = function()
    local persistence = require 'persistence'

    persistence.setup {
      dir = vim.fn.stdpath 'state' .. '/sessions/',
      options = { 'buffers', 'curdir', 'tabpages', 'winsize' },
      pre_save = nil,
    }

    local function session_exists()
      local session_file = persistence.current()
      if session_file and vim.fn.filereadable(session_file) == 1 then
        print('Session found: ' .. session_file)
        return true
      else
        print 'No session found for current directory'
        return false
      end
    end

    vim.api.nvim_create_autocmd('VimEnter', {
      group = vim.api.nvim_create_augroup('PersistenceRestore', { clear = true }),
      callback = function()
        vim.schedule(function()
          if session_exists() then
            local has_real_files = false
            for _, buf in ipairs(vim.api.nvim_list_bufs()) do
              if vim.api.nvim_buf_is_loaded(buf) and vim.bo[buf].buflisted then
                local name = vim.api.nvim_buf_get_name(buf)
                if name ~= '' and vim.fn.filereadable(name) == 1 then
                  has_real_files = true
                  break
                end
              end
            end

            if not has_real_files then
              print 'Auto-loading session...'
              persistence.load()
            else
              print 'Real files detected, skipping auto-restore'
            end
          end
        end)
      end,
    })

    vim.api.nvim_create_autocmd('VimLeavePre', {
      group = vim.api.nvim_create_augroup('PersistenceSession', { clear = true }),
      callback = function()
        local bufs = vim.tbl_filter(function(buf)
          return vim.bo[buf].buflisted and vim.bo[buf].buftype == ''
        end, vim.api.nvim_list_bufs())

        if #bufs >= 1 then
          if vim.fn.exists ':Neotree' == 2 then
            vim.cmd 'Neotree close'
          end

          print 'Saving session...'
          persistence.save()
        else
          print 'Not enough buffers to save session'
        end
      end,
    })

    -- vim.keymap.set('n', '<leader>qs', function()
    --   persistence.load()
    -- end, { desc = 'Load session' })
    -- vim.keymap.set('n', '<leader>qS', function()
    --   persistence.select()
    -- end, { desc = 'Select session' })
    -- vim.keymap.set('n', '<leader>qd', function()
    --   persistence.stop()
    -- end, { desc = 'Stop persistence' })
  end,
}
