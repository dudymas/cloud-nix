{ pkgs ? import <nixpkgs> {}
, name ? "kubens"
, repo ? "kubectx"
, owner ? "ahmetb"
, version ? "v0.9.4"
, version_path ? "v0.9.4"
, extension ? ".tar.gz"
, sha256 ? "sha256-/xZt1YVs7Xb2M3InxMYhHr/rqg/At4EsTtDYExZpUgo="
}:

pkgs.callPackage (import ../lib/gh.nix) {
  inherit name repo owner version version_path extension sha256;
}