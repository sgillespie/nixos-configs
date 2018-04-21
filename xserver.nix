# X11 windowing system configuration
{ config, pkgs, ... }:

{
  services.xserver = {
    enable = true;
    enableCtrlAltBackspace = true;
    layout = "us";
    xkbOptions = "ctrl:swapcaps";

    # Enable touchpad support
    libinput.enable = true;

    displayManager.slim = {
      enable = true;
      theme = pkgs.fetchurl {
        url = "mirror://sourceforge/slim.berlios/slim-capernoited.tar.gz";
        sha256 = "0hbby6173gnklz7jl4lm8iwscmkmm9rj2kywi3q60vb5lb3674gv";
      };
    };

    desktopManager = {
      gnome3.enable = true;
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
