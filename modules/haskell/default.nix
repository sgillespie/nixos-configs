{ pkgs, ... }:

{
  nix.settings = {
    keep-outputs = true;
    keep-derivations = true;

    trusted-public-keys = [
      "sgillespie.cachix.org-1:Zgif/WHW2IzHqbMb1z56cMmV5tLAA+zW9d5iB5w/VU4="
      "hydra.iohk.io:f/Ea+s+dFdN+3Y/G+FDgSq+a5NEWhJGzdjvKNGv0/EQ="
    ];

    substituters = [
      "https://sgillespie.cachix.org"
      "https://hydra.iohk.io"
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
