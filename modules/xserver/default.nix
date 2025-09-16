{ config, lib, pkgs, ... }:

let
  cfg = config.services.xserver;
in

with lib;

{
  imports = [
    ./nvidia.nix
    ./wayland.nix
    ./xkb.nix
  ];

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      brave
      discord
      dunst
      element-desktop
      evince
      feh
      kitty
      neovide
      passff-host
      pavucontrol
      rofi
      scrot
      slack
      spotify
      tdesktop
      xclip
      xdotool

      # GTK
      lxappearance
      dracula-theme
      materia-theme
      tela-icon-theme
      volantes-cursors
    ];

    fonts = {
      fontDir.enable = true;  # This is required for extra fonts

      packages = with pkgs; [
        lora
        merriweather
        merriweather-sans
        roboto
        roboto-mono
        source-code-pro
        corefonts
        nerd-fonts._0xproto
        nerd-fonts.fira-code
        nerd-fonts.droid-sans-mono
      ];
    };

    programs = {
      browserpass.enable = true;

      chromium.enable = true;

      firefox = {
        enable = true;
        # TODO[sgillespie]: Reenable this once this is fixed in nixpkgs
        # nativeMessagingHosts.packages = [pkgs.browserpass];
      };

      neovim.enable = true;
      thunderbird.enable = true;
    };

    services = {
      autorandr = {
        enable = true;
        defaultTarget = "default";
      };

      clipmenu.enable = true;
      libinput.enable = true;


      xserver = {
        enableCtrlAltBackspace = true;

        displayManager = {
          startx.enable = true;

          sessionCommands = ''
            autorandr --detected --change --default default
          '';
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

      desktopManager.gnome.enable = false;
    };
  };
}
