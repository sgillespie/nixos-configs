return {
  "neovim/nvim-lspconfig",
  priority = 1000,
  lazy = false,
  config = function(_, opts)
    require('lspconfig')['hls'].setup{
      filetypes = { 'haskell', 'lhaskell', 'cabal' },
      cmd = { "haskell-language-server", "--lsp" };
    }
  end,
}
