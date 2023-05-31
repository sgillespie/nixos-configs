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
      environment = "preview";
      hostAddr = "0.0.0.0";
    };
  };
}
