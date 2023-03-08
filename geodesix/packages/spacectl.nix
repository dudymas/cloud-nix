{ callPackage ? pkgs.callPackage
, pkgs ? import <nixpkgs> {} }:

callPackage (import ./lib/gh.nix) {
  name = "spacectl";
  repo = "spacectl";
  owner = "spacelift-io";
  version = "0.18.1";
  extension = ".zip";
  sha256 = "sha256-Bg+sBaNFu0MCVqvnM/SzM8IO2rzGlScxQPO1ElBhF7M=";
}