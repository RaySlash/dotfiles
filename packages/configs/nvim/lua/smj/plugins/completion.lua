return {
  { -- Autocompletion
    'saghen/blink.cmp',
    event = 'VimEnter',
    version = '1.*',
    dependencies = {
      {
        'L3MON4D3/LuaSnip',
        version = '2.*',
        build = (function()
          if vim.fn.has 'win32' == 1 or vim.fn.executable 'make' == 0 then
            return
          end
          return 'make install_jsregexp'
        end)(),
        dependencies = {
          {
            'rafamadriz/friendly-snippets',
            config = function()
              require('luasnip.loaders.from_vscode').lazy_load()
            end,
          },
        },
        opts = {},
      },
      'hrsh7th/cmp-cmdline',
      'Saghen/blink.compat',
      'xzbdmw/colorful-menu.nvim',
      'folke/lazydev.nvim',
    },
    --- @module 'blink.cmp'
    --- @type blink.cmp.Config
    opts = {
      sources = {
        default = { 'lsp', 'path', 'snippets', 'buffer', 'omni' },
        providers = {
          path = {
            score_offset = 50,
          },
          lsp = {
            score_offset = 40,
          },
          snippets = {
            score_offset = 40,
          },
          cmp_cmdline = {
            name = 'cmp_cmdline',
            module = 'blink.compat.source',
            score_offset = -100,
            opts = {
              cmp_name = 'cmdline',
            },
          },
        },
      },
      keymap = {
        preset = 'enter',
      },
      appearance = { nerd_font_variant = 'normal' },
      signature = {
        enabled = true,
        window = {
          show_documentation = true,
        },
      },
      cmdline = {
        enabled = true,
        completion = {
          menu = {
            auto_show = true,
          },
        },
        sources = function()
          local type = vim.fn.getcmdtype()
          -- Search forward and backward
          if type == '/' or type == '?' then
            return { 'buffer' }
          end
          -- Commands
          if type == ':' or type == '@' then
            return { 'cmdline', 'cmp_cmdline' }
          end
          return {}
        end,
      },
      fuzzy = {
        sorts = {
          'exact',
          -- defaults
          'score',
          'sort_text',
        },
      },
      completion = {
        menu = {
          draw = {
            treesitter = { 'lsp' },
            -- We don't need label_description now because label and label_description are already
            -- combined together in label by colorful-menu.nvim.
            columns = { { 'kind_icon' }, { 'label', gap = 1 } },
            components = {
              label = {
                text = function(ctx)
                  return require('colorful-menu').blink_components_text(ctx)
                end,
                highlight = function(ctx)
                  return require('colorful-menu').blink_components_highlight(ctx)
                end,
              },
            },
          },
        },
      },
    },
  },
}
