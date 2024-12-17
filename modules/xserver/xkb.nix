{ config, pkgs, lib, ... }:

let
  xkb_custom = pkgs.xorg.xkeyboardconfig_custom {
    layouts = config.services.xserver.xkb.extraLayouts;
  };

  xkb_patched = xkb_custom.overrideAttrs (_: {
    patches = [
      (builtins.toFile "pc.patch" ''
        diff --git i/symbols/pc w/symbols/pc
        index 8d224c34..bca1242f 100644
        --- i/symbols/pc
        +++ w/symbols/pc
        @@ -50,7 +50,7 @@ xkb_symbols "pc105" {
             modifier_map Mod4  { <SUPR> };

             key <HYPR> {[  NoSymbol, Hyper_L  ]};
        -    modifier_map Mod3  { <HYPR> };
        +    modifier_map Mod4  { <HYPR> };

             include "srvr_ctrl(fkey2vt)"
      '')
    ];
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

    extraLayouts."3l-emacs" = {
      description = "3l optimized for emacs";
      languages = ["eng"];
      symbolsFile = ./3l-emacs.xkb;
    };
  };
}
