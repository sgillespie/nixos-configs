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
          "llama3.1:8b"
          "llama3.1:8b-instruct-q6_K"
          "mistral:7b"
          "mistral:7b-instruct-q6_K"
          "llama2:7b-chat"
          "llama2:7b-chat-q6_K"
          "codellama:7b-instruct"
          "codellama:7b-instruct-q6_K"
          "zephyr:7b-beta"
          "zephyr:7b-beta-q6_K"
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
