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
    security.rtkit.enable = true;

    hardware.bluetooth.enable = true;

    services.pipewire = {
      enable = true;
      alsa = {
        enable = true;
        support32Bit = true;
      };

      pulse.enable = true;
    };
  };
}
