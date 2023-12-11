{ config, lib, pkgs, ... }:

let
  cfg = config.hardware.bluetooth;
in

with lib; {
  config = mkIf cfg.enable {
    hardware = {
      enableAllFirmware = true;

      bluetooth.settings = {
        General = {
          Enable = "Source,Sink,Media,Socket";
        };
      };

      pulseaudio = {
        enable = true;
        package = pkgs.pulseaudioFull;
      };
    };
  };
}
