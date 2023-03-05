{ callPackage ? pkgs.callPackage
, pkgs ? import <nixpkgs> {} }:

callPackage (import ./lib/gh.nix) {
  name = "atmos";
  repo = "atmos";
  owner = "cloudposse";
  version = "1.30.0";
  sha256 = "sha256-XjEY1ic7RvYwaY8vnUpct/zCm07Bch7TFT3526eASdk=";
}