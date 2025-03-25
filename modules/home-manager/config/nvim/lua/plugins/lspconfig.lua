return {
  "neovim/nvim-lspconfig",
  priority = 1000,
  lazy = false,
  opts = {
    servers = {
      hls = { 
        filetypes = { 'haskell', 'lhaskell', 'cabal' },
      },
    },
  },
}
