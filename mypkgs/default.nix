{ pkgs }: 

let
  inherit (pkgs) fetchurl haskell haskellPackages lib;
in
  rec {
    ghcDev = import ./ghc-dev.nix;

    # Elocrypt integration tests don't pass on Nix
    elocrypt = haskell.lib.dontCheck haskellPackages.elocrypt; 
  }
