{ pkgs ? import <nixpkgs> {}
, name ? "atmos"
, owner ? "cloudposse"
, repo ? name
, version ? "1.65.0"
, sha256 ? "sha256-i1QA6mjRK6+xjthmb++ChiIPwSZ79zroDBYlfaX0PG0="
}:

pkgs.callPackage (import ./lib/gh.nix) {
  inherit name owner repo version sha256;
  pname = name;
  checksum_file = "${name}_${version}_SHA256SUMS";
}