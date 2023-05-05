{
  inputs.nixpkgs.url = github:NixOS/nixpkgs/nixos-unstable;
  
  outputs = { self, nixpkgs, ... }@attrs:
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
            ./hosts/sean-nixos
            ./modules/users
            ./modules/yubikey
            ./modules/packages
            ./modules/xserver
            ./modules/virtualization
          ];
        };
      };
}

