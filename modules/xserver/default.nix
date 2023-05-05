{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    chromium
    feh
    firefox
    passff-host
    rofi
    rxvt_unicode
    scrot
    slack
    spotify
    tdesktop
    xclip
    xdotool
  ];
  
  fonts = {
    fontDir.enable = true;  # This is required for extra fonts

    fonts = with pkgs; [
      source-code-pro
      corefonts
    ];
  };

  programs.browserpass.enable = true;

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

      libinput.enable = true;

      digimend.enable = true;
      wacom.enable = true;
      
      extraLayouts."3l-emacs" = {
        description = "3l optimized for emacs";
        languages = ["eng"];
        symbolsFile = ./3l-emacs.xkb;
      };

      displayManager = {
        gdm = {
          enable = true;
          wayland = false;
        };

        sessionCommands = ''
          autorandr --detected --change --default default
        '';
      };
        
      desktopManager = {
        gnome.enable = true;
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
