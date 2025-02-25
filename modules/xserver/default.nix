{ pkgs, ... }:

{
  imports = [
    ./nvidia.nix
    ./wayland.nix
    ./xkb.nix
  ];

  environment.systemPackages = with pkgs; [
    chromium
    discord
    dunst
    element-desktop
    evince
    feh
    kitty
    passff-host
    pavucontrol
    rofi
    scrot
    slack
    spotify
    tdesktop
    xclip
    xdotool
    dracula-theme
    adwaita-icon-theme
  ];

  fonts = {
    fontDir.enable = true;  # This is required for extra fonts

    packages = with pkgs; [
      roboto
      roboto-mono
      source-code-pro
      corefonts
      nerd-fonts.fira-code
      nerd-fonts.droid-sans-mono
    ];
  };

  programs = {
    browserpass.enable = true;

    firefox = {
      enable = true;
      # TODO[sgillespie]: Reenable this once this is fixed in nixpkgs
      # nativeMessagingHosts.packages = [pkgs.browserpass];
    };
  };

  services = {
    autorandr = {
      enable = true;
      defaultTarget = "default";
    };

    clipmenu.enable = true;
    libinput.enable = true;

    xserver = {
      enable = true;
      enableCtrlAltBackspace = true;

      displayManager = {
        startx.enable = true;

        sessionCommands = ''
          autorandr --detected --change --default default
        '';
      };

      desktopManager = {
        gnome.enable = false;
      };

      windowManager.i3 = {
        enable = true;
        extraPackages = with pkgs; [
          dmenu
          i3status
          i3lock
          i3blocks
          i3status-rust
          lm_sensors
          sysstat
        ];
      };
    };
  };
}
