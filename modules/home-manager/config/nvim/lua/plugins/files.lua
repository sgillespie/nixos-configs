return {
  "stevearc/oil.nvim",
  dependencies = { 
    { "echasnovski/mini.icons", opts = {} },
  },
  lazy = false,
  opts = {},

  keys = {
    { "<leader>e", function() require("oil").open_float() end, desc = "Open Oil" },
  },
}
