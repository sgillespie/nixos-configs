{ config, pkgs, ... }:

{
  config.environment.systemPackages = with pkgs; [
    cabal-install
    ghc
    stack
  ];
}
