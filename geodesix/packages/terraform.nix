{ callPackage ? pkgs.callPackage
, pkgs ? import <nixpkgs> {} }:

callPackage (import ./lib/hashicorp.nix) {
  name = "terraform";
  version = "1.5.7";
  sha256 = "sha256-GysMuC5b4qnmFLqdvL9GwYtrf6Sv4kbNfsqhENzh7gM=";
}