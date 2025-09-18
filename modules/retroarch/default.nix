{ config,
  lib,
  pkgs,
  ...
}:

let 
  cfg = config.programs.retroarch;
in

with lib;

{
  options.programs.retroarch.enable = mkOption {
    type = types.bool;
    default = false;
    description = "Enable retroarch support";
  };

  config = mkIf cfg.enable {
    assertions = [
      {
        assertion = !cfg.enable;
        message = ''
          RetroArch is temporarily disabled due to the emulationstation-de dependency
          chain being broken.

          See: https://github.com/NixOS/nixpkgs/issues/420975.
        '';
      }
    ];

    environment.systemPackages = with pkgs; [
      emulationstation-de
      retroarch-free
    ];

    nixpkgs.config.permittedInsecurePackages = [
      "freeimage-3.18.0-unstable-2024-04-18"
    ];

    services.syncthing = { 
      enable = true;
      systemService = false;
    };
  };
}
