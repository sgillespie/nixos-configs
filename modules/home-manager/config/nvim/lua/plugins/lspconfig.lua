return {
  "neovim/nvim-lspconfig",
  priority = 1000,
  lazy = false,

  config = function(_, opts)
    require('lspconfig')['hls'].setup{
      filetypes = { 'haskell', 'lhaskell' },
      cmd = { "haskell-language-server", "--lsp" };
      settings = {
        haskell = {
          cabalFormattingProvider = "cabal-gild",
          formattingProvider = "fourmolu",
        },
      },
    }
  end,

  keys = {
    { "grn", function() vim.lsp.buf.rename() end, desc = "LSP Rename" },
    { "gra", function() vim.lsp.buf.code_action() end, desc = "LSP Code Actions" },
    { "gq", function() vim.lsp.buf.format() end, desc = "LSP Format" },
  },
}
