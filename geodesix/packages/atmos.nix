{ callPackage ? pkgs.callPackage
, pkgs ? import <nixpkgs> { }
, pkg_sha ? {
    aarch64-darwin = "sha256-XjEY1ic7RvYwaY8vnUpct/zCm07Bch7TFT3526eASdk=";
    aarch64-linux  = "sha256-h6KcSxW151Bo5qIZ0GRbKfzD2yIbzt1ysbTrcvDe9As=";
  }
}:

callPackage (import ./lib/gh.nix) {
  name = "atmos";
  repo = "atmos";
  owner = "cloudposse";
  version = "1.30.0";
  sha256 = pkg_sha.${pkgs.stdenv.hostPlatform.system};
}
