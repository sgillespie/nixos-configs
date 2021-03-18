{
  fetchFromGitHub,
  fmt,
  openimageio2
}:

openimageio2.overrideAttrs (old: {
    version = "2.1.15.0";

    patches = [];

    buildInputs = old.buildInputs ++ [fmt];

    src = fetchFromGitHub {
      owner = "OpenImageIO";
      repo = "oiio";
      rev = "Release-2.1.15.0";
      sha256 = "17rx8077acx4njvwyfjp105kn222xryy1q5i4jmi4vq13z6zgdbr";
    };
  })
