{ config, lib, pkgs, ... }:

let
  cfg = config.services.monitoring;
in

with lib;

{
  options.services.monitoring = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Enable local monitoring with Grafana and Prometheus";
    };
  };

  config = mkIf cfg.enable {
    services = {
      grafana = {
        enable = true;

        settings = {
          server = {
            http_addr = "127.0.0.1";
            http_port = 3050;
            enable_gzip = true;
          };

          analytics.reporting_enabled = false;
        };

        provision = {
          enable = true;

          datasources.settings.datasources = [
            {
              name = "Prometheus";
              type = "prometheus";
              url = "http://${config.services.prometheus.listenAddress}:${toString config.services.prometheus.port}";
              isDefault = true;
              editable = false;
            }
          ];
        };
      };

      prometheus = {
        enable = mkDefault true;

        exporters = {
          node = {
            enable = mkDefault true;
            port = 9100;
            openFirewall = true;
            firewallFilter = "-i br0 -p tcp -m tcp --dport 9100";

            enabledCollectors = [
              "systemd"
            ];
            disabledCollectors = [ "textfile" ];

          };
        } // optionalAttrs config.services.postgresql.enable {
          postgres = {
            enable = true;
            port = 9187;
            openFirewall = true;
            runAsLocalSuperUser = true;
            extraFlags = [
              "--collector.postmaster"
            ];
          };
        } // optionalAttrs config.services.cardano-node.enable {
          process = {
            enable = true;
            openFirewall = true;
            port = 9256;
            settings.process_names = [
              { 
                exe = [
                  "cardano-db-sync"
                  "cardano-node"
                ];
              }
            ];
          };
        };

        globalConfig = {
          scrape_interval = "15s";
          evaluation_interval = "15s";
        };

        scrapeConfigs = [
          {
            job_name = "node";
            static_configs = [
              {
                targets = [
                  "localhost:${toString config.services.prometheus.exporters.node.port}"
                ];
                labels.instance = "${config.networking.hostName}";
              }
            ];
            scrape_interval = "10s";
          }
        ] ++ optional config.services.postgresql.enable {
          job_name = "postgresql";
          static_configs = [
            {
              targets = [
                "localhost:${toString config.services.prometheus.exporters.postgres.port}"
              ];
              labels.instance = "${config.networking.hostName}";
            }
          ];
          scrape_interval = "5s";
        } ++ optionals config.services.cardano-db-sync.enable [
          {
            job_name = "cardano-db-sync";
            static_configs = [
              {
                targets = [
                  "localhost:8080"
                ];
                labels.instance = "${config.networking.hostName}";
              }
            ];
            metrics_path = "/";
            scrape_interval = "10s";
          }

          {
            job_name = "process";
            static_configs = [
              {
                targets = [
                  "localhost:${toString config.services.prometheus.exporters.process.port}"
                ];
                labels.instance = "${config.networking.hostName}";
              }
            ];
            scrape_interval = "10s";
          }
        ];
      };
    };

    networking.firewall.allowedTCPPorts = [ 3050 9090 ];
  };
}
