{ nixpkgs ? import <nixpkgs> {} }:

let
  inherit (nixpkgs) fetchurl pkgs stdenv;

  pbkdf2Sha512 = stdenv.mkDerivation {
    name = "pbkdf2-sha512";
    version = "latest";
    buildInputs = [pkgs.openssl];
    
    src = fetchurl {
        url = "https://raw.githubusercontent.com/NixOS/nixpkgs/master/nixos/modules/system/boot/pbkdf2-sha512.c";
        sha256 = "0pn5hh78pyh4q6qjp3abipivkgd8l39sqg5jnawz66bdzicag4l7";
    };

    unpackPhase = ":";
    buildPhase = "cc -O3 -I${pkgs.openssl.dev}/include -L${pkgs.openssl.out}/lib ${./pbkdf2-sha512.c} -o pbkdf2-sha512 -lcrypto";
    installPhase = ''
      mkdir -p $out/bin
      install -m755 ${./pbkdf2-sha512} $out/bin/pbkdf2-sha512
    '';
  };
in
  stdenv.mkDerivation {
    name = "yubikey-luks-setup";
    buildInputs = with pkgs; [
      cryptsetup
      openssl
      parted
      pbkdf2Sha512
      yubikey-personalization
    ];
    
    shellHook = ''
      rbtohex() {
        ( od -An -vtx1 | tr -d ' \n' )
      }

      hextorb() {
        ( tr '[:lower:]' '[:upper:]' | sed -e 's/\([0-9A-F]\{2\}\)/\\\\\\x\1/gI'| xargs printf )
      }
    '';

    
    inherit (pkgs) cryptsetup openssl yubikey-personalization;
  }
