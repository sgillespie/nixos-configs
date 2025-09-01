{
  inputs = {
    cardanoDbSync.url = github:sgillespie/cardano-db-sync;
    cardanoNode.url = github:input-output-hk/cardano-node?rev=40192a627d56d4c467cd88c0ceac50e83cccb0a7;
    feedback.url = github:NorfairKing/feedback;
    nixpkgs.url = github:NixOS/nixpkgs/nixos-unstable;
    nixpkgs-rpi.url = github:nvmd/nixpkgs/modules-with-keys-unstable;

    homeManager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-raspberrypi = {
      url = github:nvmd/nixos-raspberrypi/main;
      inputs.nixpkgs.follows = "nixpkgs-rpi";
    };

    sops = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Remove me after gibberish is added to haskellPackages
    gibberish.url = "github:sgillespie/gibberish";
  };

  outputs = { self, nixpkgs, cardanoNode, cardanoDbSync, homeManager, sops, ... }@attrs:
    let
      system = "x86_64-linux";

      pkgs = import nixpkgs {
        inherit system;

        overlays = [
          (import ./overlays {
            feedback = attrs.feedback.packages.${system}.default;
            gibberish = attrs.gibberish.packages.${system}.default;
          })
        ];

        config = {
          android_sdk.accept_license = true;
          allowBroken = true; # TODO[sgillespie]
          allowUnfree = true;
        };
      };

      modules = [
        ./modules/nixpkgs
        cardanoNode.nixosModules.cardano-node
        cardanoDbSync.nixosModules.cardano-db-sync
        homeManager.nixosModules.home-manager
        sops.nixosModules.sops
        ./modules/ai
        ./modules/attic
        ./modules/audio
        ./modules/cardano-node
        ./modules/console
        ./modules/home-assistant
        ./modules/home-manager
        ./modules/hydra
        ./modules/minecraft
        ./modules/networking
        ./modules/retroarch
        ./modules/users
        ./modules/yubikey
        ./modules/packages
        ./modules/postgres
        ./modules/sops
        ./modules/xserver
        ./modules/virtualization
        ./modules/haskell
      ];

      specialArgs = {
        inherit attrs;
      };
    in
      {
        nixosConfigurations = {
          sean-nixos = nixpkgs.lib.nixosSystem {
            inherit system specialArgs;
            modules = modules ++ [./hosts/sean-nixos];
          };

          sean-work = nixpkgs.lib.nixosSystem {
            inherit system specialArgs;
            modules = modules ++ [./hosts/sean-work];
          };

          sean-pi = nixpkgs.lib.nixosSystem {
            inherit specialArgs;
            system = "aarch64-linux";
            modules = modules ++ [./hosts/sean-pi];
          };

          sean-pi-public = attrs.nixos-raspberrypi.lib.nixosSystemFull {
            specialArgs = attrs;
            system = "aarch64-linux";

            modules = modules ++ [
              ./hosts/sean-pi-public
              # nvmd:nixpkgs fork seems to be lagging just a bit behind
              { disabledModules = [ ./modules/xserver ]; }
            ];
          };
        };

        legacyPackages = pkgs;

        colmena = {
          meta = {
            inherit specialArgs;
            nixpkgs = pkgs;
          };

          sean-pi = { pkgs, ...}: {
            deployment = {
              targetHost = "192.168.1.10";
            };

            nixpkgs.system = self.nixosConfigurations.sean-pi._module.args.system;
            imports = self.nixosConfigurations.sean-pi._module.args.modules;
          };
        };
      };

  nixConfig = {
    extra-substituters = [
      "https://nixos-raspberrypi.cachix.org"
    ];
    extra-trusted-public-keys = [
      "nixos-raspberrypi.cachix.org-1:4iMO9LXa8BqhU+Rpg6LQKiGa2lsNh/j2oiYLNOQ5sPI="
    ];
  };
}
