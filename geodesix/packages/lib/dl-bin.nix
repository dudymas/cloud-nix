/* This function creates a derivation for installing binaries directly
 * from releases.hashicorp.com.
 */
{ sha256
, pname
, version
, url
, dontStrip ? false

, lib
, stdenv
, fetchurl
, unzip
, autoPatchelfHook
, installPhase ? ''
    mkdir -p $out/bin
    mv ${pname} $out/bin
  ''
}:
stdenv.mkDerivation {
  inherit pname version dontStrip installPhase;
  src = fetchurl { inherit url sha256; };

  # Our source is right where the unzip happens, not in a "src/" directory (default)
  sourceRoot = ".";

  nativeBuildInputs = [ unzip ] ++ (if stdenv.isLinux then [
    # On Linux we need to do this so executables work
    autoPatchelfHook
  ] else []);
}