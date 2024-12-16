{ config, lib, pkgs, ... }:

let
  cfg = config.hardware.audio;
in

with lib; {
  options.hardware.audio.enable = mkOption {
    type = types.bool;
    default = false;
    description = "Enable audio components (bluetooth, pipewire, pulseaudio)";
  };

  config = mkIf cfg.enable {
    hardware = {
      enableAllFirmware = true;

      bluetooth = {
        enable = true;
        settings = {
          General = {
            Enable = "Source,Sink,Media,Socket";
          };
        };
      };

      pulseaudio = {
        enable = true;
        package = pkgs.pulseaudioFull;
      };
    };

    services.pipewire.enable = false;
  };
}
