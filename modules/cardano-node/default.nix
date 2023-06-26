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
    ];

    services = {
      cardano-node = {
        environment = "preprod";
        hostAddr = "0.0.0.0";
        rtsArgs = [ "-N2" "-I0" "-A16m" "-qg" "-qb" "--disable-delayed-os-memory-return" "-c"];
      };

      cardano-db-sync = {
        enable = true;
        cluster = "preprod";
        socketPath = cfg.socketPath 0;
        # disableLedger = true;
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
        };
    };

    systemd.services = {
      cardano-db-sync = {
        serviceConfig.User = "cardano-node";
        wantedBy = [];
      };

      cardano-node = {
        serviceConfig.Restart = lib.mkForce "no";
        wantedBy = [];
      };
    };
  };
}
