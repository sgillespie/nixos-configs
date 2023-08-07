{
  inputs.nixpkgs.url = github:NixOS/nixpkgs/nixos-unstable;
  inputs.cardanoNode.url = github:input-output-hk/cardano-node?rev=69a117b7be3db0f4ce6d9fc5cd4c16a2a409dcb8;
  inputs.cardanoDbSync.url = github:input-output-hk/cardano-db-sync?rev=6e69a80797f2d68423b25ca7787e81533b367e42;
  inputs.feedback.url = github:NorfairKing/feedback;

  outputs = { self, nixpkgs, cardanoNode, cardanoDbSync, ... }@attrs:
    let
      system = "x86_64-linux";

      pkgs = import nixpkgs {
        inherit system;

        overlays = [
          (import ./overlays {
            feedback = attrs.feedback.packages.${system}.default;
          })
        ];

        config = {
          android_sdk.accept_license = true;
          allowBroken = true; # TODO[sgillespie]
          allowUnfree = true;
        };
      };
    in
      {
        nixosConfigurations.sean-nixos = nixpkgs.lib.nixosSystem {
          inherit system;

          specialArgs = {
            inherit attrs;
            pkgs = pkgs;
          };

          modules = [
            cardanoNode.nixosModules.cardano-node
            cardanoDbSync.nixosModules.cardano-db-sync
            ./hosts/sean-nixos
            ./modules/cardano-node
            ./modules/users
            ./modules/yubikey
            ./modules/packages
            ./modules/postgres
            ./modules/xserver
            ./modules/virtualization
            ./modules/haskell
          ];
        };
      };
}
