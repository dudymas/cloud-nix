/* This function creates a derivation for installing binaries directly
 * from releases.hashicorp.com.
 */
{ name
, version
, sha256
, system ? builtins.currentSystem
, pname ? name

, lib
, pkgs ? import <nixpkgs> {}
, callPackage ? pkgs.callPackage
}:

let
  # Mapping of Nix systems to the GOOS/GOARCH pairs.
  systemMap = {
    x86_64-linux  = "linux_amd64";
    i686-linux    = "linux_386";
    x86_64-darwin = "darwin_amd64";
    i686-darwin   = "darwin_386";
    aarch64-linux = "linux_arm64";
    aarch64-darwin = "darwin_arm64";
  };

  # Get our system
  goSystem = systemMap.${system} or (throw "unsupported system: ${system}");

  # url for downloading composed of all the other stuff we built up.
  url = "https://releases.hashicorp.com/${name}/${version}/${name}_${version}_${goSystem}.zip";

  # Stripping breaks darwin Go binaries
  dontStrip = lib.strings.hasPrefix "darwin" goSystem;

in callPackage ./dl-bin.nix {
  inherit pname version sha256 url dontStrip;
}