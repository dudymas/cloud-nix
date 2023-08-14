{ callPackage ? pkgs.callPackage
, pkgs ? import <nixpkgs> {} }:

callPackage (import ./lib/gh.nix) {
  name = "atmos";
  repo = "atmos";
  owner = "cloudposse";
  version = "1.43.0";
  sha256 = "sha256-3V8t3KFQkrDbMlZutPRfXH8zPV1Y74+n1BdMGF4rJKU=";
}