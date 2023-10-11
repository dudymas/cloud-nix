{ callPackage ? pkgs.callPackage
, pkgs ? import <nixpkgs> {} }:

callPackage (import ./lib/hashicorp.nix) {
  name = "terraform";
  version = "1.5.5";
  sha256 = "sha256-OzCZZNdu5ZIh3Jmh+7NHdeygI6JHz1r3KyE/jq0LL88=";
}