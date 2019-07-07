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
    
    xserver = {
      enable = true;
      enableCtrlAltBackspace = true;
      layout = "us";
      xkbOptions = "ctrl:swapcaps";

      # Enable touchpad support
      libinput.enable = true;

      displayManager = {
        lightdm = {
          enable = true;
          background = "${pkgs.adapta-backgrounds}/share/backgrounds/adapta/tri-fadeno.jpg";
          greeters.gtk.enable = true;
          greeters.gtk.iconTheme.package = pkgs.numix-icon-theme;
          greeters.gtk.iconTheme.name = "Numix";
          greeters.gtk.theme.package = pkgs.adapta-gtk-theme;
          greeters.gtk.theme.name = "Adapta";
        };
        
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
