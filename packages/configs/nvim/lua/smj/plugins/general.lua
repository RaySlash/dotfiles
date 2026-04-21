return {
  'NMAC427/guess-indent.nvim', -- Detect tabstop and shiftwidth automatically
  {
    'lewis6991/gitsigns.nvim',
    opts = {
      signs = {
        add = { text = '+' },
        change = { text = '~' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
      },
    },
  },
  { 'folke/todo-comments.nvim', event = 'VimEnter', dependencies = { 'nvim-lua/plenary.nvim' }, opts = { signs = false } },
  {
    'nvim-mini/mini.nvim',
    version = '*',
    dependencies = {
      { 'nvim-mini/mini.pairs',       version = '*' },
      { 'nvim-mini/mini.ai',          version = '*' },
      { 'nvim-mini/mini.surround',    version = '*' },
      { 'nvim-mini/mini.move',        version = '*' },
      { 'nvim-mini/mini.indentscope', version = '*' },
      -- { 'nvim-mini/mini.cursorword', version = '*' },
    },
    config = function()
      require('mini.ai').setup()
      require('mini.indentscope').setup()
      require('mini.pairs').setup()
      require('mini.surround').setup()
      -- require('mini.cursorword').setup()
      require('mini.move').setup {
        mappings = {
          -- Move visual selection in Visual mode. Defaults are Alt (Meta) + hjkl.
          left = '<C-h>',
          right = '<C-l>',
          down = '<C-j>',
          up = '<C-k>',

          -- Move current line in Normal mode
          line_left = '<C-h>',
          line_right = '<C-l>',
          line_down = '<C-j>',
          line_up = '<C-k>',
        },
      }
    end,
  },
  {
    'mbbill/undotree',
    keys = { { '<leader>ut', '<cmd>UndotreeToggle<CR>', mode = { 'n' }, desc = 'Undo Tree', noremap = true } },
  },
  {
    'folke/which-key.nvim',
    config = function(_)
      require('which-key').setup {
        preset = 'helix',
      }
    end,
  },
  {
    'cbochs/grapple.nvim',
    opts = {
      scope = 'git', -- also try out "git_branch"
    },
    event = { 'BufReadPost', 'BufNewFile' },
    cmd = 'Grapple',
    keys = {
      { '<leader>tg', '<cmd>Grapple toggle<cr>',          desc = 'Grapple toggle tag' },
      { '<leader>tw', '<cmd>Grapple toggle_tags<cr>',     desc = 'Grapple open tags window' },
      { '<C-x>n',     '<cmd>Grapple cycle_tags next<cr>', desc = 'Grapple cycle next tag' },
      { '<C-x>p',     '<cmd>Grapple cycle_tags prev<cr>', desc = 'Grapple cycle previous tag' },
    },
  },
  {
    url = 'https://codeberg.org/andyg/leap.nvim',
    config = function()
      vim.keymap.set('n', 's', function()
        require('leap').leap { target_windows = { vim.api.nvim_get_current_win() } }
      end)
      vim.keymap.set('n', 's', '<Plug>(leap-from-window)') -- or S maybe
      vim.keymap.set({ 'x', 'o' }, 'f', '<Plug>(leap-forward)')
      vim.keymap.set({ 'x', 'o' }, 'F', '<Plug>(leap-backward)')
    end,
  },
  -- {
  --   'rmagatti/auto-session',
  --   config = function()
  --     vim.o.sessionoptions = 'blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions'
  --     require('auto-session').setup {
  --       auto_create = function()
  --         local cmd = 'git rev-parse --is-inside-work-tree'
  --         return vim.fn.system(cmd) == 'true\n'
  --       end,
  --     }
  --   end,
  -- },
  {
    'NeogitOrg/neogit',
    keys = {
      { '<C-x>g', '<cmd>Neogit<CR>', mode = { 'n' }, desc = 'Git Console [Neogit]', noremap = true },
    },
    dependecies = {
      { 'nvim-lua/plenary.nvim', config = true },
    },
    config = function()
      require('neogit').setup {
        commit_date_format = 'strftime',
      }
    end,
  },
}
