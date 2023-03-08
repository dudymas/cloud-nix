{ callPackage ? pkgs.callPackage
, pkgs ? import <nixpkgs> {} }:

callPackage (import ./lib/hashicorp.nix) {
  name = "terraform";
  version = "1.3.4";
  sha256 = "sha256-oCwZlC7dDFsrSsc9COjBwoI4iV2K/Y6Yp9q4DMKi2SA=";
}