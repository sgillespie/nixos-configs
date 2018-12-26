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
    xserver = {
      enable = true;
      enableCtrlAltBackspace = true;
      layout = "us";
      xkbOptions = "ctrl:swapcaps";

      # Enable touchpad support
      libinput.enable = true;

      displayManager.sddm = {
        enable = true;
        theme = "maya";
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

      xrandrHeads = [
        {
          output = "DP1-2";
          primary = true;
          monitorConfig = ''
            Option "LeftOf" "DP2-2"
          '';
        }

        {
          output = "DP2-2";
        }
      ];
    };
  };
}
