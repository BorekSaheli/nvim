return {
  "nvim-telescope/telescope.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons",
    {
      "nvim-telescope/telescope-fzf-native.nvim",
      build = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release",
    },
    "nvim-telescope/telescope-ui-select.nvim",
  },
  keys = {
    { "<leader>fp", "<cmd>Telescope builtin<cr>", desc = "Builtin [p]ickers" },
    { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "[f]iles" },
    { "<leader>fF", "<cmd>Telescope find_files hidden=true<cr>", desc = "hidden [F]iles" },
    { "<leader>fg", "<cmd>Telescope live_grep<cr>", desc = "Live [g]rep" },
    { "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "[b]uffers" },
    { "<leader><leader>", "<cmd>Telescope buffers<cr>", desc = "buffers" },
    { "<leader>fh", "<cmd>Telescope help_tags<cr>", desc = "[h]elp tags" },
  },
  config = function(_, opts)
    local telescope = require("telescope")
    local actions = require("telescope.actions")

    telescope.setup({
      defaults = {
        layout_strategy = "vertical",
        mappings = {
          i = {
            ["<esc>"] = actions.close,
            ["<C-j>"] = actions.select_horizontal,
            ["<C-l>"] = actions.select_vertical,
          },
        },
      },
      extensions = {
        ["ui-select"] = {
          require("telescope.themes").get_dropdown {
            -- even more opts
          }
        }
      }
    })

    telescope.load_extension("fzf")
    telescope.load_extension("ui-select")
  end,
}