{ pkgs ? import <nixpkgs> {}
, name ? "atmos"
, owner ? "cloudposse"
, repo ? name
, version ? "1.45.3"
# , sha256 ? "sha256-58Jrx5NfX6TFSwp/qh5riMR+FpuNH8KZu4somJdWYB4="
, sha256 ? "sha256-B38sVVI7eM7UackoT8LLaKTuT8HW2aZgaWEYWBW5b9U="
}:

pkgs.callPackage (import ./lib/gh.nix) {
  inherit name owner repo version sha256;
  pname = name;
  checksum_file = "${name}_${version}_SHA256SUMS";
}