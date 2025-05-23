return {
  {
    "NeogitOrg/neogit",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "sindrets/diffview.nvim",
      "nvim-telescope/telescope.nvim",
    },
    config = true,

    keys = {
      { "<leader>g", function() require("neogit").open() end, desc = "Open Neogit" },
    },
  },
}
