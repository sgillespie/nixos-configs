{ config, lib, pkgs, ... }:

let
  cfg = config.programs.haskell;
  # TODO[sgillespie]: Is this the right place?
  agda = pkgs.agda.withPackages (p: [ p.standard-library ]);
in 

with lib; 

{
  options.programs.haskell.enable = mkOption {
    type = types.bool;
    default = true;
    description = "Enable Haskell development support";
  };

  config = mkIf cfg.enable {
    nix.settings = {
      allow-import-from-derivation = true;
      keep-outputs = true;
      keep-derivations = true;

      trusted-public-keys = [
        "sgillespie.cachix.org-1:Zgif/WHW2IzHqbMb1z56cMmV5tLAA+zW9d5iB5w/VU4="
        "hydra.iohk.io:f/Ea+s+dFdN+3Y/G+FDgSq+a5NEWhJGzdjvKNGv0/EQ="
        "loony-tools:pr9m4BkM/5/eSTZlkQyRt57Jz7OMBxNSUiMC4FkcNfk="
      ];

      substituters = [
        "https://sgillespie.cachix.org"
        "https://cache.iog.io"
        "https://cache.zw3rk.com"
      ];
    };

    programs.direnv.enable = true;

    environment = {
      systemPackages = with pkgs; [
        agda
        cabal-install
        cachix
        haskell-language-server
        haskell.compiler.ghc96
        haskellPackages.fourmolu
        hlint
        nix-direnv
        stack
      ] ++ pkgs.lib.optionals (pkgs.system == "x86_64-linux") [
        feedback
      ];
    };
  };
}
