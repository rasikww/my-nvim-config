local gemini_model = 'gemini-3-flash-preview'

return {
  'olimorris/codecompanion.nvim',
  version = '^18.0.0',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-treesitter/nvim-treesitter',
    'lalitmee/codecompanion-spinners.nvim',
  },
  cmd = { 'CodeCompanionActions', 'CodeCompanionChat', 'CodeCompanion' },
  opts = {
    adapters = {
      http = {
        gemini = function()
          return require('codecompanion.adapters').extend('gemini', {
            env = {
              api_key = vim.env.GEMINI_API_KEY,
            },
          })
        end,
      },
      acp = {
        gemini_cli = function()
          return require('codecompanion.adapters').extend('gemini_cli', {
            defaults = {
              auth_method = 'gemini-api-key',
            },
            env = {
              api_key = vim.env.GEMINI_API_KEY,
            },
          })
        end,
      },
    },

    interactions = {
      chat = {
        adapter = {
          name = 'gemini',
          model = gemini_model,
        },
        roles = {
          user = 'rasikww',
        },
        opts = {
          completion_provider = 'blink',
        },
        keymaps = {
          send = {
            modes = {
              i = { '<C-s>' },
            },
          },
          completion = {
            modes = {
              i = '<C-x>',
            },
          },
        },
        slash_commands = {
          ['buffer'] = {
            keymaps = {
              modes = {
                i = '<C-b>',
              },
            },
          },
          ['fetch'] = {
            keymaps = {
              modes = {
                i = '<C-f>',
              },
            },
          },
          ['file'] = {
            keymaps = {
              modes = {
                i = '<C-p>',
              },
            },
          },
          ['help'] = {
            opts = {
              max_lines = 1000,
            },
          },
        },
      },
      inline = {
        adapter = {
          name = 'gemini',
          model = gemini_model,
        },
      },
      chat_cli = {
        adapter = {
          name = 'gemini_cli',
        },
      },
      display = {
        action_palette = {
          provider = 'default',
        },
        chat = {
          show_preferences = true,
          show_header_separator = true,
          show_tools_processing = true,
          show_token_count = true,
        },
      },
      opts = {
        log_level = 'DEBUG',
      },
    },
    extensions = {
      spinner = {
        -- enabled = true, -- This is the default
        opts = {
          -- Your spinner configuration goes here
          style = 'fidget',
        },
      },
    },
  },
  keys = {
    {
      '<leader>cca',
      '<cmd>CodeCompanionActions<CR>',
      desc = 'CodeCompanion Actions',
      mode = { 'n', 'v' },
    },
    {
      '<leader>cct',
      '<cmd>CodeCompanionChat Toggle<CR>',
      desc = 'Toggle CodeCompanion Chat',
      mode = { 'n', 'v' },
    },
    {
      '<leader>ccs',
      '<cmd>CodeCompanionChat Add<CR>',
      desc = 'Add code to chat',
      mode = { 'v' },
    },
    {
      '<leader>cci',
      '<cmd>CodeCompanion<CR>',
      desc = 'CodeCompanion Inline',
      mode = { 'n', 'v' },
    },
  },
}
