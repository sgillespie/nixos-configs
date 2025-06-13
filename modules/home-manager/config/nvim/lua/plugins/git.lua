return {
  {
    "NeogitOrg/neogit",
    commit = "9bb1e73c534f767607e0a888f3de4c942825c501",
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
