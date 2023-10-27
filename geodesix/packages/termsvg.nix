{ pkgs ? import <nixpkgs> {}
, name ? "termsvg"
, owner ? "MrMarble"
, repo ? name
, version ? "0.6.1"
, sha256 ? "sha256-RCNwSAUwElg2M3CWcZo+PakFnV8I1xyTq1FFD0h7Hyo="
}:
let
  # if the system is any flavor of darwin, we should use .zip for extension
  extension = if pkgs.stdenv.isDarwin then ".zip" else ".tar.gz";
  systemMap = {
    x86_64-linux = "linux-amd64";
    i686-linux = "linux-386";
    x86_64-darwin = "darwin-amd64";
    aarch64-linux = "linux-arm64";
    aarch64-darwin = "darwin-arm64";
  };
  fileNamer = config: "${name}-${version}-${config.system_mapping}${extension}";
in pkgs.callPackage (import ./lib/gh.nix) {
  inherit name owner repo version sha256 systemMap extension fileNamer;
  pname = name;
  checksum_file = "${name}-${version}-checksums.txt";
}