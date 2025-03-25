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
          ports = [ "192.168.0.201:19132:19132/udp" ];
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

        minecraft-creative = {
          image = "itzg/minecraft-bedrock-server";
          volumes = [ "bedrock-data-creative-1:/data" ];
          ports = [ "192.168.0.202:19132:19132/udp" ];
          environment = {
            EULA = "TRUE";
            SERVER_NAME = "Local Creative";
            GAMEMODE = "creative";
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

      hosts  = {
        "192.168.0.201" = [
          "survival.minecraft.local"
        ];
        "192.168.0.202" = [
          "creative.minecraft.local"
        ];
      };

      interfaces = {
        enabcm6e4ei0.ipv4.addresses = [
          {
            address = "192.168.0.100";
            prefixLength = 24;
          }
          {
            address = "192.168.0.201";
            prefixLength = 24;
          }
          {
            address = "192.168.0.202";
            prefixLength = 24;
          }
        ];
      };

      defaultGateway = "192.168.0.1";
      nameservers = [ "192.168.0.1" ];
    };
  };
}
