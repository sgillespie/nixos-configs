{ config, lib, pkgs, ... }:


let
  cfg = config.services.yubikey;
in

with lib;

{
  options.services.yubikey.enable = mkOption {
    type = types.bool;
    default = false;
    description = "Enable PAM yubikey support";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      pinentry-curses
      pinentry-gtk2
      pinentry-rofi
      yubikey-personalization
      yubioath-flutter
    ];

    security.pam = {
      u2f.control = "required";

      services = {
        login.u2fAuth = true;
      };
    };

    programs = {
      gnupg.agent = {
        enable = true;
        enableSSHSupport = true;
        pinentryPackage = mkDefault pkgs.pinentry-rofi;
      };

      ssh.startAgent = false;
    };

    services.pcscd.enable = true;
  };
}
