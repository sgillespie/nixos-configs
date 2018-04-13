# X11 windowing system configuration
{ config, pkgs, ... }:

{
  services.xserver = {
    enable = true;
    layout = "us";
    xkbOptions = "ctrl:swapcaps, terminate:ctrl_alt_bksp";

    # Enable touchpad support
    libinput.enable = true;

    displayManager.sddm = {
      enable = true;
      theme = "breeze";
    };

    desktopManager = {
      gnome3.enable = true;
      plasma5.enable = true;
    };

    windowManager.i3 = {
      enable = true;
      extraPackages = with pkgs; [
        dmenu
        i3status
        i3lock
      ];
    };
  };
}
