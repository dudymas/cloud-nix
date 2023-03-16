{ callPackage ? pkgs.callPackage
, pkgs ? import <nixpkgs> {}
, pkg_sha ? {
    aarch64-darwin = "sha256-oCwZlC7dDFsrSsc9COjBwoI4iV2K/Y6Yp9q4DMKi2SA=";
    aarch64-linux  = "sha256-ZTgca2Gy0amIkhmfZJpXZP9adyCApz1w+GYyReZALDk=";
  }
}:

callPackage (import ./lib/hashicorp.nix) {
  name = "terraform";
  version = "1.3.4";
  sha256 = pkg_sha.${pkgs.system};
}