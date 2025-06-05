return {
  'nvim-lualine/lualine.nvim',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  config = function()
    --------------------------------------------------------------------
    -- 1.  Borek colour palette (taken from borektheme.omp.json)
    --------------------------------------------------------------------
    local colors = {
      base      = '#000000',
      text      = '#f9e2af',
      surface0  = '#313244',
      crust     = '#11111b',
      overlay1  = '#7f849c',

      peach     = '#deb259',  -- yellow-orange
      sapphire  = '#74c7ec',  -- cyan-blue
      lavender  = '#93b7ab',  -- soft teal
      mauve     = '#c6003c',  -- magenta-red
      teal      = '#95ae3e',  -- olive-green
    }

    --------------------------------------------------------------------
    -- 2.  Lualine theme table that mirrors Borek
    --------------------------------------------------------------------
    local borek_theme = {
      normal  = {
        a = { fg = colors.base,   bg = colors.peach,    gui = 'bold' },
        b = { fg = colors.text,   bg = colors.surface0 },
        c = { fg = colors.text,   bg = colors.crust    },
      },
      insert  = {
        a = { fg = colors.base,   bg = colors.sapphire, gui = 'bold' },
        b = { fg = colors.text,   bg = colors.surface0 },
        c = { fg = colors.text,   bg = colors.crust    },
      },
      visual  = {
        a = { fg = colors.base,   bg = colors.lavender, gui = 'bold' },
        b = { fg = colors.text,   bg = colors.surface0 },
        c = { fg = colors.text,   bg = colors.crust    },
      },
      replace = {
        a = { fg = colors.base,   bg = colors.mauve,    gui = 'bold' },
        b = { fg = colors.text,   bg = colors.surface0 },
        c = { fg = colors.text,   bg = colors.crust    },
      },
      command = {
        a = { fg = colors.base,   bg = colors.teal,     gui = 'bold' },
        b = { fg = colors.text,   bg = colors.surface0 },
        c = { fg = colors.text,   bg = colors.crust    },
      },
      inactive = {
        a = { fg = colors.overlay1, bg = colors.surface0 },
        b = { fg = colors.overlay1, bg = colors.surface0 },
        c = { fg = colors.overlay1, bg = colors.crust    },
      },
    }

    --------------------------------------------------------------------
    -- 3.  Custom highlight just for the Python logo
    --------------------------------------------------------------------
    vim.api.nvim_set_hl(0, 'LualinePythonIcon', { fg = colors.peach })

    --------------------------------------------------------------------
    -- 4.  Helper callbacks (unchanged)
    --------------------------------------------------------------------
    local function get_venv()
      local venv = vim.env.VIRTUAL_ENV
      return venv and venv:match('([^/]+)$') or nil
    end

    local function filetype_with_venv()
      local ft = vim.bo.filetype
      local venv = get_venv()
      if venv and ft == 'python' then
        return '%#LualinePythonIcon# %* venv: ' .. venv
      end
      return ft
    end

    local function copilot_status()
      local path = vim.fn.stdpath('data') .. '/copilot_state'
      local f = io.open(path, 'r')
      if f then
        local s = f:read('*a'); f:close()
        return (s == '1') and '' or ''
      end
      return ''
    end

    local function diagnostic_status()
      local path = vim.fn.stdpath('data') .. '/diagnostic_state'
      local f = io.open(path, 'r')
      if f then
        local s = f:read('*a'); f:close()
        return (s == '1') and '󱖫  on' or '󱖫 off'
      end
      return '󱖫  on'
    end

    --------------------------------------------------------------------
    -- 5.  Lualine setup
    --------------------------------------------------------------------
    require('lualine').setup({
      options = {
        theme               = borek_theme,
        component_separators = '',
        section_separators   = { left = '', right = '' },
      },
      sections = {
        lualine_x = {
          'encoding',
          'fileformat',
          copilot_status,
          diagnostic_status,
          filetype_with_venv,
        },
      },
    })
  end,
}
