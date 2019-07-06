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
        gdm.enable = true;
        
        job.preStart =  ''
          if [[ -e "/etc/gdm/.config/monitors.xml" ]]; then
            mkdir -p /run/gdm/.config
            cp /etc/gdm/.config/monitors.xml /run/gdm/.config
          fi
        '';
        
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
