{ mkDerivation, base, hpack, stdenv, yesod-core }:
mkDerivation {
  pname = "minimal";
  version = "0.0.0";
  src = ./.;
  isLibrary = true;
  isExecutable = true;
  libraryHaskellDepends = [ base yesod-core ];
  libraryToolDepends = [ hpack ];
  executableHaskellDepends = [ base yesod-core ];
  preConfigure = "hpack";
  license = stdenv.lib.licenses.gpl3;
}
