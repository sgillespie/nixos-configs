{ pkgs, ... }:

{
  nix.settings.trusted-public-keys = [
    "hydra.iohk.io:f/Ea+s+dFdN+3Y/G+FDgSq+a5NEWhJGzdjvKNGv0/EQ="
  ];
  nix.settings.substituters = [
    "https://cache.iog.io"
  ];

  environment.systemPackages = with pkgs; [
    cabal-install
    haskell.compiler.ghc96
    stack
  ];
}
