{
  blender,
  fetchurl,
  pugixml,
  python3Packages
}:

let
  inherit (python3Packages) python numpy;
in

blender.overrideAttrs (old: rec {
  version = "2.92.0";

  src = fetchurl {
    url = "https://download.blender.org/source/${old.pname}-${version}.tar.xz";
    sha256 = "15a5vffn18a920286x0avbc2rap56k6y531wgibq68r90g2cz4g7";
  };

  buildInputs = old.buildInputs ++ [pugixml];

  NIX_CFLAGS_COMPILE = old.NIX_CFLAGS_COMPILE +
    " -I${numpy}/lib/${python.libPrefix}/site-packages/numpy/core/include";
})
