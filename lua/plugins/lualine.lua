return {
  "nvim-lualine/lualine.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    -- ===== palette (kept) =====
    local colors = {
      rosewater = "#f5e0dc",
      flamingo = "#f2cdcd",
      pink = "#f5c2e7",
      mauve = "#cba6f7",
      red = "#f38ba8",
      maroon = "#eba0ac",
      peach = "#fab387",
      yellow = "#e5c890",
      green = "#a6e3a1",
      teal = "#94e2d5",
      sky = "#89dceb",
      sapphire = "#74c7ec",
      blue = "#89b4fa",
      lavender = "#b4befe",
      text = "#cdd6f4",
      subtext1 = "#bac2de",
      subtext0 = "#a6adc8",
      overlay2 = "#9399b2",
      overlay1 = "#7f849c",
      overlay0 = "#6c7086",
      surface2 = "#585b70",
      surface1 = "#45475a",
      surface0 = "#313244",
      base = "#1e1e2e",
      mantle = "#181825",
      crust = "#11111b",
    }

    -- ===== theme (kept) =====
    local catppuccin_theme = {
      normal = {
        a = { fg = colors.base, bg = colors.yellow, gui = "bold" },
        b = { fg = colors.text, bg = colors.surface0 },
        c = { fg = colors.text, bg = colors.base },
      },
      insert = {
        a = { fg = colors.base, bg = colors.green, gui = "bold" },
        b = { fg = colors.text, bg = colors.surface0 },
        c = { fg = colors.text, bg = colors.base },
      },
      visual = {
        a = { fg = colors.base, bg = colors.mauve, gui = "bold" },
        b = { fg = colors.text, bg = colors.surface0 },
        c = { fg = colors.text, bg = colors.base },
      },
      replace = {
        a = { fg = colors.base, bg = colors.red, gui = "bold" },
        b = { fg = colors.text, bg = colors.surface0 },
        c = { fg = colors.text, bg = colors.base },
      },
      command = {
        a = { fg = colors.base, bg = colors.sapphire, gui = "bold" },
        b = { fg = colors.text, bg = colors.surface0 },
        c = { fg = colors.text, bg = colors.base },
      },
      inactive = {
        a = { fg = colors.overlay1, bg = colors.surface0 },
        b = { fg = colors.overlay1, bg = colors.surface0 },
        c = { fg = colors.overlay1, bg = colors.base },
      },
    }

    -- One-time HL for the Python icon (kept)
    vim.api.nvim_set_hl(0, "LualinePythonIcon", { fg = colors.peach })

    -- ===== ultra-light helpers & caches =====
    local cache = {
      venv_path = false,
      venv_name = nil,
      pyver = nil,
      display = nil, -- ready-to-print " <venv> <ver>"
    }

    local function trim(s)
      return (s:gsub("^%s+", ""):gsub("%s+$", ""))
    end

    local function compute_venv_name(path)
      if not path or path == "" then return nil end
      local name = path:match("([^/\\]+)$")
      if name == "venv" then
        local parent = path:match("^(.*)[/\\][^/\\]+$")
        if parent then name = parent:match("([^/\\]+)$") or name end
      end
      return name
    end

    local function set_display()
      if cache.venv_name then
        local ver = cache.pyver and (" " .. cache.pyver) or ""
        cache.display = "%#LualinePythonIcon#%* " .. cache.venv_name .. ver
      else
        cache.display = nil
      end
    end

    -- Async, called only when VIRTUAL_ENV changes (or on first run)
    local function refresh_python_info()
      local v = vim.env.VIRTUAL_ENV or false
      if v == cache.venv_path then return end
      cache.venv_path = v
      cache.venv_name = compute_venv_name(v)
      cache.pyver = nil
      set_display()

      if not cache.venv_name then
        vim.cmd("redrawstatus")
        return
      end

      local cmd = { "python", "-c", 'import sys;print(".".join(map(str, sys.version_info[:3])))' }

      local done = function(ver)
        if ver and ver ~= "" then
          cache.pyver = trim(ver)
          set_display()
          pcall(vim.cmd, "redrawstatus")
        end
      end

      if vim.system then
        vim.system(cmd, { text = true }, function(res)
          if res and res.code == 0 then done(res.stdout) end
        end)
      else
        vim.fn.jobstart(cmd, {
          stdout_buffered = true,
          on_stdout = function(_, data)
            if data and #data > 0 then done(data[1] or "") end
          end,
        })
      end
    end

    -- Update on events likely to imply env change / relevant to Python
    vim.api.nvim_create_autocmd({ "VimEnter", "DirChanged", "FocusGained" }, {
      callback = refresh_python_info,
    })
    vim.api.nvim_create_autocmd({ "BufEnter", "FileType" }, {
      callback = function()
        if vim.bo.filetype == "python" then refresh_python_info() end
      end,
    })

    -- Zero-cost providers (use state module getters)
    local state = require("core.state")
    local function copilot_status()
      return state.is_copilot_enabled() and "" or ""
    end
    local function diagnostic_toggle()
      return state.is_diagnostics_enabled() and "󱖫 on" or "󱖫 off"
    end
    local function completion_toggle()
      return state.is_completion_enabled() and "󰍉 on" or "󰍉 off"
    end

    -- Filetype/venv component: no IO; uses cache
    local function filetype_with_venv()
      local ft = vim.bo.filetype
      if ft == "python" and cache.display then return cache.display end
      return ft
    end

    -- Conditionally show less-useful bits to keep it snappy & clean
    local function wide()
      return vim.fn.winwidth(0) > 80
    end
    local function nondefault_encoding()
      return (vim.opt.encoding:get() or "utf-8") ~= "utf-8"
    end
    local function nondefault_fileformat()
      return (vim.bo.fileformat or "unix") ~= "unix"
    end

    require("lualine").setup({
      options = {
        theme = catppuccin_theme,
        component_separators = "",
        section_separators = { left = "", right = "" },
        globalstatus = true,
        disabled_filetypes = { statusline = { "alpha", "starter", "dashboard" } },
        -- Keep default refresh; faster refresh increases CPU, slower can feel laggy.
        -- refresh = { statusline = 1000 },
      },
      sections = {
        lualine_a = { { "mode" } },
        lualine_b = {
          -- Use gitsigns-provided head (cheap) + builtin diff (lazy)
          { "b:gitsigns_head", icon = "", color = { fg = colors.text, bg = colors.surface0 } },
          { "diff", cond = wide },
          { "diagnostics", cond = wide },
        },
        lualine_c = { { "filename", path = 1 } },
        lualine_x = {
          { "encoding", cond = nondefault_encoding },
          { "fileformat", cond = nondefault_fileformat },
          copilot_status,
          diagnostic_toggle,
          completion_toggle,
          filetype_with_venv,
        },
        lualine_y = { { "progress" } },
        lualine_z = { { "location" } },
      },
      inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = { { "filename", path = 1 } },
        lualine_x = {},
        lualine_y = {},
        lualine_z = {},
      },
    })
  end,
}
