{ config, pkgs, lib, ... }:

let
  cfg = config.services.xserver;

  xkb_custom = pkgs.xorg.xkeyboardconfig_custom {
    layouts = config.services.xserver.xkb.extraLayouts;
  };

in 

with lib;

{
  config = mkIf cfg.enable {
    environment.sessionVariables = {
      # runtime override supported by multiple libraries e. g. libxkbcommon
      # https://xkbcommon.org/doc/current/group__include-path.html
      XKB_CONFIG_ROOT = config.services.xserver.xkb.dir;
    };

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
