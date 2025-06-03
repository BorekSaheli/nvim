return {
  "folke/flash.nvim",
  opts = {},
  keys = {
    { "f", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash (f)" },
    { "F", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash (F)" },
    { "t", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash (t)" },
    { "T", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash (T)" },

    { "s", function() require("flash").jump() end, mode = { "n", "x", "o" }, desc = "Flash" },
    { "S", function() require("flash").treesitter() end, mode = { "n", "x", "o" }, desc = "Flash Treesitter" },
    { "r", function() require("flash").remote() end, mode = "o", desc = "Remote Flash" },
    { "R", function() require("flash").treesitter_search() end, mode = { "o", "x" }, desc = "Treesitter Search" },
  }

}