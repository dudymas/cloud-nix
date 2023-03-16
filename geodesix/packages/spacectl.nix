{ callPackage ? pkgs.callPackage
, pkgs ? import <nixpkgs> {}
, pkg_sha ? {
    aarch64-darwin = "sha256-Bg+sBaNFu0MCVqvnM/SzM8IO2rzGlScxQPO1ElBhF7M=";
    aarch64-linux  = "sha256-lsrFlgIUfNRwqOqn8d/QQuci5Bpg41+lVx9BgTypmoI=";
  }
}:

callPackage (import ./lib/gh.nix) {
  name = "spacectl";
  repo = "spacectl";
  owner = "spacelift-io";
  version = "0.18.1";
  extension = ".zip";
  sha256 = pkg_sha.${pkgs.system};
}