{ config, lib, pkgs, ... }:

let
  cfg = config.services.hydra;
in

with lib;

{
  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ hydra-cli ];

    nix.settings = {
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

    services.hydra = {
      hydraURL = "http://localhost:3000"; # externally visible URL
      notificationSender = "hydra@localhost"; # e-mail of Hydra service
      buildMachinesFiles = [];
      useSubstitutes = true;
    };
  };
}
