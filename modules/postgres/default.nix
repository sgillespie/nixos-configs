{ config, lib, pkgs, ... }:

let
  cfg = config.services.postgresql;
in

with lib;

{
  config = mkIf cfg.enable {
    services.postgresql = {
      ensureDatabases = [ "sgillespie" "hydra" ];

      ensureUsers = [
        {
          name = "sgillespie";
          ensureClauses.superuser = true;
        }

        {
          name = "hydra";
          ensureClauses.superuser = true;
        }
      ] ++ optionals config.services.monitoring.enable [
        {
          name = "postgres_exporter";
        }
      ];

      dataDir = "/blockchain/postgresql/${config.services.postgresql.package.psqlSchema}";

      package = pkgs.postgresql_16;
    };

    environment.systemPackages = with pkgs; [
      pgcli
    ];
  };
}
