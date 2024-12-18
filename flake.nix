{
  inputs = {
    nixpkgs.url = github:NixOS/nixpkgs/nixos-unstable;
    cardanoNode.url = github:input-output-hk/cardano-node?ref=10.1.1-pre;
    cardanoDbSync.url = github:IntersectMBO/cardano-db-sync;
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
        cardanoNode.nixosModules.cardano-node
        cardanoDbSync.nixosModules.cardano-db-sync
        homeManager.nixosModules.home-manager
        sops.nixosModules.sops
        ./modules/audio
        ./modules/cardano-node
        ./modules/console
        ./modules/home-manager
        ./modules/hydra
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
        inherit attrs pkgs;
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
            system = "aarch64-linux";

            modules = [
              {
                nixpkgs.overlays = [
                  (import ./overlays {
                    feedback = attrs.feedback.packages.${system}.default;
                    gibberish = attrs.gibberish.packages.${system}.default;
                  })
                ];
                nixpkgs.config = {
                  allowUnfree = true;
                  allowUnsupportedSystem = true;
                };
              }

              homeManager.nixosModules.home-manager
              sops.nixosModules.sops
              ./modules/console
              ./modules/home-assistant
              ./modules/home-manager
              ./modules/networking
              ./modules/sops
              ./modules/users
              ./hosts/sean-pi
            ];
          };
        };

        legacyPackages = pkgs;
      };
}
