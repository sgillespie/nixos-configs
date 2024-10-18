{ config, lib, pkgs, ... }:

let
  cfg = config.hardware.bluetooth;
in

with lib; {
  config = mkIf cfg.enable {
    security.rtkit.enable = true;

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
