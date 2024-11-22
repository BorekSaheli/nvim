return {
  "p00f/nvim-ts-rainbow",
  event = "BufRead",
  config = function()
    require("nvim-treesitter.configs").setup {
      rainbow = {
        enable = true,
        extended_mode = true, -- Highlight also non-bracket delimiters like HTML tags
        max_file_lines = nil, -- Do not limit to certain file sizes
        -- Custom bracket colors: peach, pink, blue, purple
        colors = {
          "#deb259", -- Peach
          "#a44aa2", -- Pink
          "#a44aa2", -- Blue
          "#a556b8", -- Purple
        },
        -- Ensure all languages, including Python, are enabled
        disable = { },
      },
      -- Ensure Treesitter is enabled for Python and other languages
      ensure_installed = { "python", "lua", "javascript", "typescript", "html", "css", "cpp", "java" },
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
      },
    }

    -- Optional: Automatically install missing parsers when entering buffer
    local ts_install = require("nvim-treesitter.install")
    ts_install.ensure_installed({ "python" })
  end,
}