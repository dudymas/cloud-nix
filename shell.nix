{ goVersion ? "19"
, overlays ? [ (self: super: { go = super."go_1_${toString goVersion}"; }) ]
, pkgs ? import <nixpkgs> { inherit overlays; }
}:
pkgs.mkShell {
  packages = with pkgs; [
    go #set in overlays
    gotools # https://github.com/golangci/golangci-lint
    golangci-lint # The Go language server (for IDEs and such)
    gopls # https://pkg.go.dev/github.com/ramya-rao-a/go-outline
    go-outline # https://github.com/uudashr/gopkgs
    gopkgs
    atmos
    terraform
    geodesic
  ];
  shellHook = ''
    export GEODESIC_WORKDIR=$PWD
    export GEODESIC_HOST_CWD=$PWD
    export ATMOS_BASE_PATH=$PWD
  '';
}