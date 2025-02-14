{ pkgs ? import <nixpkgs> {}
, name ? "atmos"
, owner ? "cloudposse"
, repo ? name
, version ? "1.160.4"
, sha256 ? "sha256-wRPyW+UDMcr8PxVHr0PFn9z7ihUAnPWAJ4R30QQvoYY="
}:

pkgs.callPackage (import ./lib/gh.nix) {
  inherit name owner repo version sha256;
  pname = name;
  checksum_file = "${name}_${version}_SHA256SUMS";
}
