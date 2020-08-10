# X11 windowing system configuration
{ config, pkgs, ... }:

{
  fonts = {
    enableFontDir = true;  # This is required for extra fonts

    # Extra fonts
    fonts = with pkgs; [
      source-code-pro
      corefonts
    ];
  };

  services = {
    autorandr = {
      enable = true;
      defaultTarget = "default";
    };

    clipmenu.enable = true;
    
    xserver = {
      enable = true;
      enableCtrlAltBackspace = true;
      layout = "3l-emacs";
      # xkbOptions = "ctrl:swapcaps";

      extraLayouts."3l-emacs" = {
        description = "3l optimized for emacs";
        languages = ["eng"];
        symbolsFile = /etc/nixos/3l-emacs.xkb;
      };
      
      # Enable touchpad support
      libinput.enable = true;

      displayManager = {
        gdm.enable = true;

        sessionCommands = ''
          autorandr --detected --change --default default
        '';
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
  };
}
