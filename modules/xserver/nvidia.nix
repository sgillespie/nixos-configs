{ pkgs, lib, config, ... }:

let
  cfg = config.hardware.nvidiaUnfree;
in

with lib;

{
  options.hardware.nvidiaUnfree.enable = mkOption {
    type = types.bool;
    default = false;
    description = "Enable Nvidia proprietary support";
  };

  config = mkIf cfg.enable {
    services.xserver.videoDrivers = [ "nvidia" ];

    hardware = {
      graphics.enable = true;
      nvidia.modesetting.enable = true;
    };

    environment.systemPackages = with pkgs; [ vulkan-tools vulkan-validation-layers ];
  };
}
