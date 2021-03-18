{ config, pkgs, ... }:

{
  imports = [
    ./crypto-currency.nix
    ./haskell.nix
  ];
}
