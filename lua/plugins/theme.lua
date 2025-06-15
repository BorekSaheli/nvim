-- Theme: Pop N Rice
return {
    name = "pop-n-rice",
    priority = 1000,
    lazy = false,
    config = function()
        vim.opt.guifont = "Consolas:h12"
        vim.cmd.colorscheme("pop-n-rice")
    end,
}
