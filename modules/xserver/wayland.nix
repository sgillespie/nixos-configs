{ config, pkgs, lib, ... }:

let
  cfg = config.programs.wayland;
in

with lib;

{
  options.programs.wayland.enable = mkOption {
    type = types.bool;
    default = false;
    description = "Enable wayland compositors (sway)";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      grim # screenshot functionality
      wayland
      wdisplays # tool to configure displays
      wl-clipboard # wl-copy and wl-paste for copy/paste from stdin / stdout
      xdg-utils

      # Sway
      swayidle
      swaylock
      waybar
    ];

    xdg.portal = {
      enable = true;
      wlr.enable = true;
      extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
      config.sway.default = lib.mkForce [ "wlr" "gtk" ];
    };

    programs = {
      sway = {
        enable = true;
        wrapperFeatures.gtk = true;
        extraOptions = [ "--unsupported-gpu" ];
        extraSessionCommands = ''
          # General wayland environment variables
          export QT_QPA_PLATFORM="wayland;xcb"
          export QT_WAYLAND_DISABLE_WINDOWDECORATION=1
        '';
      };
    };
  };
}
