{ callPackage ? pkgs.callPackage
, pkgs ? import <nixpkgs> {} }:

callPackage (import ./lib/gh.nix) {
  name = "atmos";
  repo = "atmos";
  owner = "cloudposse";
  version = "1.45.3";
  sha256 = "sha256-58Jrx5NfX6TFSwp/qh5riMR+FpuNH8KZu4somJdWYB4=";
}