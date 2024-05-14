{ config,
  lib,
  pkgs,
  attrs,
  ...
}:

let
  cfg = config.services.cardano-node;
  currentSystem = "x86_64-linux";
  inherit (attrs) cardanoNode;
in

with lib; {
  config = mkIf cfg.enable {
    environment.systemPackages = [
      cardanoNode.legacyPackages."${currentSystem}".cardano-cli
      cardanoNode.legacyPackages."${currentSystem}".cardano-node
    ];

    services = {
      cardano-node = {
        environment = "mainnet";
        hostAddr = "0.0.0.0";
        rtsArgs = ["-N2" "-I0" "-A16m" "-qg" "-qb" "--disable-delayed-os-memory-return" "-c"];
      };

      cardano-db-sync = {
        enable = true;
        cluster = "mainnet";
        socketPath = cfg.socketPath 0;
      };

      postgresql =
        let
          postgres = config.services.cardano-db-sync.postgres;
        in {
          ensureDatabases = [ postgres.database ];
          ensureUsers = [
            { name = postgres.user;
              ensureClauses.superuser = true;
            }
          ];

          identMap = ''
            users root ${postgres.user}
            users cardano-db-sync ${postgres.user}
            users cardano-node ${postgres.user}
            users smash ${postgres.user}
            users postgres ${postgres.user}
            users sgillespie ${postgres.user}
            users postgres postgres
            users sgillespie sgillespie

            users hydra hydra
            users hydra-queue-runner hydra
            users hydra-www hydra
            users root hydra
            # The postgres user is used to create the pg_trgm extension for the hydra database
            users postgres postgres
          '';

          authentication = ''
            local all all ident map=users
          '';

          settings = {
            # Snapshot creation requires more than 20 connections
            max_connections = 50;
            shared_buffers = "16GB";
            effective_cache_size = "48GB";
            maintenance_work_mem = "2GB";
            checkpoint_completion_target = 0.9;
            wal_buffers = "16MB";
            default_statistics_target = 100;
            random_page_cost = 1.1;
            effective_io_concurrency = 200;
            work_mem = "209715kB";
            huge_pages = "try";
            min_wal_size = "2GB";
            max_wal_size = "8GB";
            max_worker_processes = 32;
            max_parallel_workers_per_gather = 4;
            max_parallel_workers = 32;
            max_parallel_maintenance_workers = 4;
          };
        };
    };

    systemd.services =
      let
        dbSync = config.services.cardano-db-sync;
      in
        lib.optionalAttrs dbSync.enable {
          cardano-db-sync = {
            serviceConfig = {
              User = "cardano-node";
            };
          };
        };
  };
}
