return {
  {
    'josstei/whisk.nvim',
    config = function()
      require('whisk').setup {
        cursor = {
          duration = 150,
          easing = 'linear',
        },
        performance = { enabled = true },
      }
    end,
  },
  {
    'iamcco/markdown-preview.nvim',
    cmd = { 'MarkdownPreviewToggle', 'MarkdownPreview', 'MarkdownPreviewStop' },
    build = 'cd app && yarn install',
    init = function()
      vim.g.mkdp_filetypes = { 'markdown' }
    end,
    ft = { 'markdown' },
  },
  {
    'nvim-lualine/lualine.nvim',
    config = function()
      require('lualine').setup {
        globalstatus = true,
        options = {
          theme = 'auto',
          icons_enabled = true,
          component_separators = { left = '|', right = '|' },
          section_separators = { left = '', right = '' },
        },
        extensions = { 'fugitive', 'fzf', 'toggleterm', 'quickfix' },
      }
    end,
  },
  {
    'luukvbaal/statuscol.nvim',
    config = function()
      local builtin = require 'statuscol.builtin'
      require('statuscol').setup {
        setopt = true,
        relculright = true,
        segments = {
          { text = { '%s' }, click = 'v:lua.ScSa' },
          {
            text = { builtin.lnumfunc, ' ' },
            condition = { true, builtin.not_empty },
            click = 'v:lua.ScLa',
          },
        },
      }
    end,
  },
  {
    'goolord/alpha-nvim',
    dependencies = {
      'nvim-mini/mini.icons',
      'nvim-lua/plenary.nvim',
    },
    config = function()
      require('alpha').setup(require('alpha.themes.theta').config)
    end,
  },
  {
    'dstein64/vim-startuptime',
    config = function(_)
      vim.g.startuptime_event_width = 0
      vim.g.startuptime_tries = 10
    end,
  },
  {
    'brenoprata10/nvim-highlight-colors',
    config = function(_)
      require('nvim-highlight-colors').setup {
        render = 'virtual',
        virtual_symbol = '■',
        enable_named_colors = true,
        enable_tailwind = true,
      }
    end,
  },
}
