{ config, pkgs, lib, ... }:

let
  xkb_custom = pkgs.xorg.xkeyboardconfig_custom {
    layouts = config.services.xserver.xkb.extraLayouts;
  };

  xkb_patched = xkb_custom.overrideAttrs (_: {
    src = pkgs.fetchgit {
      url = "https://gitlab.freedesktop.org/wismill/xkeyboard-config.git";
      rev = "6b662798639ae04b20a7ced50b89918abc9e5b00";
      sha256 = "sha256-KlLG+QEHtxNIDh/ooZyD4P9UZt54ydawUvWH7QrwRsM=";
    };
  });
in {
  environment.sessionVariables = {
    # runtime override supported by multiple libraries e. g. libxkbcommon
    # https://xkbcommon.org/doc/current/group__include-path.html
    XKB_CONFIG_ROOT = config.services.xserver.xkb.dir;
  };

  services.xserver.xkb = {
    layout = "3l-emacs";
    dir = lib.mkForce "${xkb_patched}/etc/X11/xkb";
    options = "terminate:ctrl_alt_bksp";

    extraLayouts."3l-emacs" = {
      description = "3l optimized for emacs";
      languages = ["eng"];
      symbolsFile = ./3l-emacs.xkb;
    };
  };
}
