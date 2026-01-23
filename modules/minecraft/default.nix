{ config, lib, pkgs, ... }: 

let
  cfg = config.services.minecraft-bedrock-server;
in

with lib;

{
  options.services.minecraft-bedrock-server.enable = mkOption  {
    type = types.bool;
    default = false;
    description = "Enable Minecraft Bedrock Server";
  };

  config = mkIf cfg.enable {
    virtualisation.oci-containers = {
      backend = "podman";
      containers = {
        minecraft-survival = {
          image = "itzg/minecraft-bedrock-server";
          volumes = [ "bedrock-data-survival-1:/data" ];
          ports = [ "192.168.1.11:19132:19132/udp" ];
          environment = {
            EULA = "TRUE";
            SERVER_NAME = "Local Survival";
            GAME_MODE = "Survival";
            DIFFICULTY = "easy";
            ALLOW_CHEATS = "true";
            ONLINE_MODE = "true";
            ENABLE_LAN_VISIBILITY = "true";
            DEFAULT_PLAYER_PERMISSION_LEVEL = "operator";
          };
        };
      };
    };

    networking = {
      firewall = {
        allowedTCPPorts = [ 19132 ];
        allowedUDPPorts = [ 19132 ];
      };
    };
  };
}
