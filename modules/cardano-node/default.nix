{ config,
  lib,
  pkgs,
  cardanoNode,
  ...
}:

let
  cfg = config.services.cardano-node;
in

with lib; {
  config = mkIf cfg.enable {
    services.cardano-node = {
      environment = "mainnet";
      hostAddr = "0.0.0.0";
      rtsArgs = [ "-N2" "-I0" "-A16m" "-qg" "-qb" "--disable-delayed-os-memory-return" "-c"];
    };
  };
}
