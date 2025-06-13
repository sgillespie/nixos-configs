{
  inputs = {
    nixpkgs.url = github:NixOS/nixpkgs/nixos-unstable;
    cardanoNode.url = github:input-output-hk/cardano-node?rev=40192a627d56d4c467cd88c0ceac50e83cccb0a7;
    cardanoDbSync.url = github:sgillespie/cardano-db-sync?rev=43b2f07869f01f975260fedf92dc1fa34727caaf;
    feedback.url = github:NorfairKing/feedback;

    homeManager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
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
        ./modules/attic
        ./modules/audio
        ./modules/cardano-node
        ./modules/console
        ./modules/home-assistant
        ./modules/home-manager
        ./modules/hydra
        ./modules/minecraft
        ./modules/networking
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
        };

        legacyPackages = pkgs;

        colmena = {
          meta = {
            inherit specialArgs;
            nixpkgs = pkgs;
          };

          sean-pi = { pkgs, ...}: {
            deployment = {
              targetHost = "pi.local";
            };

            nixpkgs.system = self.nixosConfigurations.sean-pi._module.args.system;
            imports = self.nixosConfigurations.sean-pi._module.args.modules;
          };
        };
      };
}
