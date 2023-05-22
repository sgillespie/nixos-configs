{ pkgs, ... }:

{
  nix.settings = {
    keep-outputs = true;
    keep-derivations = true;

    trusted-public-keys = [
      "hydra.iohk.io:f/Ea+s+dFdN+3Y/G+FDgSq+a5NEWhJGzdjvKNGv0/EQ="
    ];

    substituters = [
      "https://cache.iog.io"
    ];
  };

  environment = {
    pathsToLink = [
      "/share/nix-direnv"
    ];
    
    systemPackages = with pkgs; [
      cabal-install
      direnv
      nix-direnv
      haskell.compiler.ghc96
      haskell-language-server
      stack
    ];
  };
}
