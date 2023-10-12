{ pkgs ? import <nixpkgs> {}
, pname ? "updatecli"
, owner ? pname
, repo ? pname
, extension ? ".tar.gz"
, version ? "0.62.0"
, sha256 ? "sha256-4esu0eBTMpI+4JyPcrvDg749nTmehLle1DhSPcP7uBo="
}:

let
  name = pname;
  systemMap = {
    x86_64-linux = "Linux_x86_64";
    i686-linux = "Linux_386";
    x86_64-darwin = "Darwin_x86_64";
    i686-darwin = "Darwin_386";
    aarch64-linux = "Linux_arm64";
    aarch64-darwin = "Darwin_arm64";
  };
  fileNamer = config: "${pname}_${config.system_mapping}${extension}";
in pkgs.callPackage (import ./lib/gh.nix) {
  inherit name pname version owner repo extension systemMap fileNamer;
  # description = "GitOps to Update anything";
  # homepage = "https://github.com/updatecli/updatecli";
}