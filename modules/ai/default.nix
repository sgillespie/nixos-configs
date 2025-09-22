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
        loadModels = [
          "llama2:7b-chat"
          "llama3.1:8b-instruct-q4_K_M"
          "llama3.1:8b"
          "mistral:7b"
          "mistral:7b-instruct"
          "codellama:7b-instruct"
          "zephyr:7b-beta"
        ];
      };

      open-webui = {
        enable = true;
        port = 3000;
      };
    };

    environment.systemPackages = [ pkgs.ollama ];

  };
}
