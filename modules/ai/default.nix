{ config, lib, pkgs, ... }:

let
  cfg = config.services.ai;
in

with lib;

{
  options.services.ai.enable = mkOption {
    type = types.bool;
    default = false;
    description = "Enable local AI services";
  };

  config = mkIf cfg.enable {
    services = {
      ollama = {
        enable = true;
        acceleration = "cuda";
      };

      open-webui = {
        enable = true;
        port = 3000;
      };
    };

    environment.systemPackages = [ pkgs.ollama ];

  };
}
