{ config, lib, pkgs, attrs, ... }:

let
  cfg = config.sops;
in

with lib; {
  options.sops.enable = mkOption {
    type = types.bool;
    default = false;
    description = "Enable sops-nix support for encrypted secrets";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      openssh
      sops
      ssh-to-age
      ssh-to-pgp
    ];

    sops = {
      defaultSopsFile = ../../secrets/default.yaml;
      age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
      secrets.secret_key = {};
    };
  };
}
