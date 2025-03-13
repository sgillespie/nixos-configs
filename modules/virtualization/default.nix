{ config, lib, pkgs, ... }:

let
  cfg = config.services.virtualisation;
in

with lib;

{
  options.services.virtualisation.enable = mkOption {
    type = types.bool;
    default = false;
    description = "Enable virtualisation support";
  };

  config = mkIf cfg.enable {
    virtualisation.docker = {
      enable = true;
      enableOnBoot = true;
    };

    environment.systemPackages = with pkgs; [ docker-compose ];
  };
}
