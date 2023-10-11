{ callPackage ? pkgs.callPackage
, pkgs ? import <nixpkgs> {}
, pname ? "updatecli"
, owner ? pname
, repo ? repo
, extension ? ".tar.gz"
, version ? "0.62.0"
, version_sha ? "sha256-4esu0eBTMpI+4JyPcrvDg749nTmehLle1DhSPcP7uBo="
, fetchurl ? pkgs.fetchurl
}:

let
  checksums = import ./lib/gh-checksums.nix { inherit repo owner version version_sha fetchurl; };
  systemMap = {
    x86_64-linux = "Linux_x86_64";
    i686-linux = "Linux_386";
    x86_64-darwin = "Darwin_x86_64";
    i686-darwin = "Darwin_386";
    aarch64-linux = "Linux_arm64";
    aarch64-darwin = "Darwin_arm64";
  };
  system_moniker = systemMap.${pkgs.system};
  filename = "${pname}_${system_moniker}${extension}";
in callPackage (import ./lib/gh.nix) {
  inherit pname version owner repo extension filename;
  name = "${pname}";

  sha256 = checksums."${filename}";

  # description = "GitOps to Update anything";
  # homepage = "https://github.com/updatecli/updatecli";
}