{ pkgs ? import <nixpkgs> {}
, name ? "spacectl"
, repo ? "spacectl"
, owner ? "spacelift-io"
, version ? "0.28.0"
, extension ? ".zip"
, sha256 ? "sha256-Bg+sBaNFu0MCVqvnM/SzM8IO2rzGlScxQPO1ElBhF7M="
}:

pkgs.callPackage (import ./lib/gh.nix) {
  inherit name version owner repo extension;
  checksum_file = "${name}_${version}_SHA256SUMS";
}