local M = {}

local colors = {
    bg = "#000000",
    fg = "#f9e2af",
    dim = "#a6adc8",
    comment = "#7f849c",
    dark_comment = "#4a4a57",
    surface0 = "#313244",
    surface1 = "#45475a",
    surface2 = "#585b70",
    accent = "#deb259",
    teal = "#74c7ec",
    aqua = "#93b7ab",
    magenta = "#c6003c",
    green = "#9dba2a",
    olive = "#95ae3e",
    cyan = "#89dceb",
    number = "#af4b57",
    operator = "#2f8870",
    special = "#5f9e25",
}

local function hl(group, opts)
    vim.api.nvim_set_hl(0, group, opts)
end

function M.setup()
    vim.o.termguicolors = true

    hl("Normal",         { fg = colors.fg, bg = colors.bg })
    hl("NormalFloat",    { fg = colors.fg, bg = colors.bg })
    hl("Comment",        { fg = colors.comment, italic = true })
    hl("Constant",       { fg = colors.number })
    hl("String",         { fg = colors.olive })
    hl("Character",      { fg = colors.olive })
    hl("Number",         { fg = colors.number, bold = true })
    hl("Boolean",        { fg = colors.number, bold = true })
    hl("Float",          { fg = colors.number, bold = true })
    hl("Identifier",     { fg = colors.aqua })
    hl("Function",       { fg = colors.accent, bold = true })
    hl("Statement",      { fg = colors.magenta })
    hl("Conditional",    { fg = colors.magenta })
    hl("Repeat",         { fg = colors.magenta })
    hl("Operator",       { fg = colors.operator })
    hl("Keyword",        { fg = colors.magenta })
    hl("Type",           { fg = colors.teal })
    hl("Special",        { fg = colors.cyan })
    hl("PreProc",        { fg = colors.teal })
    hl("Todo",           { fg = colors.accent, bold = true })
    hl("LineNr",         { fg = colors.comment, bg = "NONE" })
    hl("CursorLineNr",   { fg = colors.fg, bg = "NONE", bold = true })
    hl("SignColumn",     { bg = "NONE" })

    -- Treesitter highlights
    hl("@keyword.function.python", { fg = colors.special, bold = true, italic = true })
    hl("@number",                 { fg = colors.number, bold = true })
    hl("@float",                  { fg = colors.number, bold = true })
    hl("@boolean",                { fg = colors.number, bold = true })
    hl("@constant.builtin",       { fg = colors.number, bold = true })
    hl("@function.builtin",       { fg = colors.accent, bold = true })
    hl("@function.python",        { fg = colors.accent, bold = true })
    hl("@function.method.python", { fg = colors.accent, bold = true })
    hl("@keyword.type",           { fg = colors.accent, bold = true })
    hl("@operator",               { fg = colors.operator })
    hl("@keyword.operator.python",{ fg = colors.magenta })
    hl("@punctuation.delimiter.python", { fg = colors.fg })
end

return M
