{ nixpkgs ? import <nixpkgs> {}, compiler ? "ghcHEAD" }:

let
  inherit (nixpkgs) pkgs;
  ghc = pkgs.haskell.packages.${compiler}.ghc;
in
  with nixpkgs; lib.overrideDerivation ghc
  (drv: {
    name = "ghc-dev";
    nativeBuildInputs = drv.nativeBuildInputs ++ [
      arcanist
      git
      python36Packages.sphinx
      texlive.combined.scheme-basic
      zsh
    ];
  })

