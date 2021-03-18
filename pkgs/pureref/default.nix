{ stdenv, fetchurl, appimageTools }:

appimageTools.wrapType2 rec {
  name = "pureref";

  src = /home/sgillespie/downloads/PureRef-1.11.1_x64.Appimage;

  meta = with stdenv.lib; {
    homepage = "https://pureref.com/";
    description = "";
    longDescription = ''
    '';
    license = licenses.unfree;
    platforms = ["x86_64-linux"];
    maintainers = ["Sean Gillespie"];
  };
}
