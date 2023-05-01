{ version ? "3.11.2"
, sha256 ? "sha256-9ho6pVgn3i2MZKIGP9dEthi0Q+0GOHG3n1IGnpCBMVE="
, pkgs ? import <nixpkgs> {}
, system ? pkgs.stdenv.hostPlatform.system
, callPackage ? pkgs.callPackage
}:

let
  # Mapping of Nix systems to the GOOS/GOARCH pairs.
  systemMap = {
    x86_64-linux  = "linux-amd64";
    i686-linux    = "linux-386";
    x86_64-darwin = "darwin-amd64";
    i686-darwin   = "darwin-386";
    aarch64-linux = "linux-arm64";
    aarch64-darwin = "darwin-arm64";
  };
  
  binSystem = systemMap.${system} or (throw "Unsupported system: ${system}");

in callPackage (import ../lib/dl-bin.nix) {
  inherit version sha256;
  pname = "helm";
  url = "https://get.helm.sh/helm-v${version}-${binSystem}.tar.gz";
  installPhase = ''
    mkdir -p $out/bin
    mv ${binSystem}/helm $out/bin
  '';
}