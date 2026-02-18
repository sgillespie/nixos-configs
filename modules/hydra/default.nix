{ config, lib, pkgs, ... }:

let
  inherit (config.sops) secrets;
  cfg = config.services.hydra;
  sopsFile = ../../secrets/hydra.yaml;
in

with lib;

{
  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ hydra-cli ];

    nix.buildMachines = [
      { 
        hostName = "localhost";
        protocol = null;
        system = "x86_64-linux";
        supportedFeatures = ["kvm" "nixos-test" "big-parallel" "benchmark"];
        maxJobs = 8;
      }
    ];

    nix.settings = {
      allow-import-from-derivation = true;

      system-features = [
        "big-parallel"
        "kvm"
        "nixos-test"
        "recursive-nix"
      ];

      extra-experimental-features = [
        "recursive-nix"
        "fetch-closure"
      ];

      allowed-uris = [
        "github:"
        "git+https://github.com/"
        "git+ssh://github.com/"
      ];
    };

    services = {
      hydra = {
        hydraURL = "http://localhost:3000"; # externally visible URL
        notificationSender = "hydra@localhost"; # e-mail of Hydra service
        buildMachinesFiles = [ "/etc/nix/machines" ];
        useSubstitutes = true;
        extraConfig = ''
          allow_import_from_derivation = true
        '';
      };

      hydra-github-bridge.public = {
        enable = true;
        ghAppId = 2831135;
        ghAppInstallIds = "[(\"sgillespie\", 109092203), (\"sgillespie00\", 109092868)]";
        ghAppKeyFile = secrets."hydra-tools/gh-app-key".path;
        ghTokenFile = secrets."hydra-tools/gh-secret".path;
        ghUserAgent = "";
        hydraHost = "build.sgillespie.dev";
        hydraUser = "hydratools";
        hydraPassFile = secrets."hydra-tools/pass".path;
        port = 8811;
      };

      nginx = {
        enable = true;
        recommendedProxySettings = mkDefault true;

        virtualHosts."build.sgillespie.dev" = {
          forceSSL = true;
          enableACME = true;
          acmeRoot = null;

          locations."/".proxyPass = "http://[::]:3000";
        };

        virtualHosts."hydra-tools.sgillespie.dev" = {
          forceSSL = true;
          enableACME = true;
          acmeRoot = null;

          locations."/".proxyPass = "http://127.0.0.1:8811";
        };
      };
    };

    sops.secrets = {
      "hydra-tools/pass" = {
        inherit sopsFile;
        owner = "hydra";
      };

      "hydra-tools/gh-secret" = {
        inherit sopsFile;
        owner = "hydra";
      };

      "hydra-tools/gh-app-key" = {
        inherit sopsFile;
        owner = "hydra";
      };
    };
  };
}
