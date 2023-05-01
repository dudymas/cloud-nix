{ callPackage ? pkgs.callPackage
, pkgs ? import <nixpkgs> {} }:

callPackage (import ../lib/gh.nix) {
  name = "kubens";
  repo = "kubectx";
  owner = "ahmetb";
  version = "v0.9.4";
  version_path = "v0.9.4";
  extension = ".tar.gz";
  sha256 = "sha256-266RkBbU6/oJeAE1ys2deHstOILxPD1bPDyIMYBJYgk=";
}