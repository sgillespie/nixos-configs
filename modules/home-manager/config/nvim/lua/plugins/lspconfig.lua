return {
  {
    "neovim/nvim-lspconfig",
    priority = 1000,
    lazy = false,

    config = function(_, opts)
      vim.lsp.set_log_level('debug')
      vim.lsp.enable('hls')
      vim.lsp.config('hls', {
        filetypes = { 'haskell', 'lhaskell' },
        cmd = { "haskell-language-server", "--lsp", "--debug" };
        settings = {
          haskell = {
            cabalFormattingProvider = "cabal-gild",
            formattingProvider = "fourmolu",
          },
        },
      })
    end,

    keys = {
      { "grn", function() vim.lsp.buf.rename() end, desc = "LSP Rename" },
      { "gra", function() vim.lsp.buf.code_action() end, desc = "LSP Code Actions" },
      { "gq", function() vim.lsp.buf.format() end, desc = "LSP Format" },
    },
  },

  {
    "folke/trouble.nvim",
    cmd = "Trouble",
    opts = {},
  },
}
