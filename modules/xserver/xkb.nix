{ config, pkgs, lib, ... }:

let
  cfg = config.services.xserver;

in 

with lib;

{
  config = mkIf cfg.enable {
    services.xserver.xkb = {
      layout = "3l-emacs";
      options = "terminate:ctrl_alt_bksp,ctrl:swapcaps";

      extraLayouts."3l-emacs" = {
        description = "3l optimized for emacs";
        languages = ["eng"];
        symbolsFile = ./3l-emacs.xkb;
      };
    };
  };
}
