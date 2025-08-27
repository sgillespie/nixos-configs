{ pkgs, lib, config, ... }:

let
  cfg = config.hardware.nvidia;
in

with lib;

{
  options.hardware.nvidia.enable = mkOption {
    type = types.bool;
    default = false;
    description = "Enable Nvidia support";
  };

  config = mkIf cfg.enable {
    services.xserver.videoDrivers = ["nvidia"];

    hardware = {
      graphics.enable = true;

      nvidia = {
        modesetting.enable = true;
        nvidiaSettings = true;
        open = false;
        package = config.boot.kernelPackages.nvidiaPackages.stable;

        powerManagement = {
          enable = false;
          finegrained = false;
        };
      };
    };

    environment.systemPackages = with pkgs; [
      clinfo
      cudatoolkit
      vulkan-tools
      vulkan-validation-layers
    ];
  };
}
