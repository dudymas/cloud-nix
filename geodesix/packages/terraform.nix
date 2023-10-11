{ callPackage ? pkgs.callPackage
, pkgs ? import <nixpkgs> {} }:

callPackage (import ./lib/hashicorp.nix) {
  name = "terraform";
  version = "1.5.5";
  sha256 = "sha256-x/3t20c5/dW62p1F/XhuLLr26eNkaT7uRcg+lSgdrTo=";
}