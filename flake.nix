{
  inputs.nixpkgs.url = github:NixOS/nixpkgs/nixos-unstable;
  inputs.cardanoNode.url = github:input-output-hk/cardano-node;
  
  outputs = { self, nixpkgs, cardanoNode, ... }@attrs:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        overlays = [
          (import ./overlays)
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

