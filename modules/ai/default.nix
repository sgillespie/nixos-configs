{ config, lib, pkgs, ... }:

let
  inherit (config.sops) secrets;
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
        package = pkgs.ollama-cuda;
      };

      open-webui = {
        enable = true;
        port = 3000;

        package = pkgs.open-webui.overridePythonAttrs (old: {
          dependencies = old.dependencies ++ 
            (with pkgs.python3Packages; [
              cloudscraper # For local_web_scrape
              html2text    # For local_web_scrape
              itsdangerous # Required for Open WebUI
            ]);
        });
      };

      searx = {
        enable = true;
        environmentFile = secrets."searxng/environment".path;

        settings = {
          server = {
            port = 3010;
            secret_key = "$SEARX_SECRET_KEY";
          };

          search.formats = [
            "html"
            "json"
          ];

          limiter_settings = {
            botdetection = {
              ip_limit.linktoken = false;

              ip_lists = {
                block_ip = [];
                pass_ip = [];
              };
            };
          };
        };
      };
    };

    environment.systemPackages = with pkgs; [
      claude-code
      nodejs
      ollama
      opencode
      oterm
      uv
    ];

    programs.nix-ld.enable = true;

    sops.secrets."searxng/environment" = {};
  };
}
