{ pkgs ? import <nixpkgs> {}
, name ? "atmos"
, owner ? "cloudposse"
, repo ? name
, version ? "1.70.0"
, sha256 ? "sha256-ZZKbN63P83e9jcDY8E0S9ZH3BS9EFCmEntaMtwivqvU="
}:

pkgs.callPackage (import ./lib/gh.nix) {
  inherit name owner repo version sha256;
  pname = name;
  checksum_file = "${name}_${version}_SHA256SUMS";
}
