{ overlays ? [ ]
, pkgs ? import <nixpkgs> { inherit overlays; }
}:
pkgs.mkShell {
  packages = with pkgs; [
    atmos
    awscli
    bash-completion
    crudini
    kubectl
    terraform

    geodesic
  ];

  bash = pkgs.bashInteractive;
  geodesic = pkgs.geodesic;
  
  aloha = "hello";

  shellHook = ''
    export GEODESIC_SHELL='$bash/bin/bash --init-file $geodesic/etc/profile'
    alias geodesix=$GEODESIC_SHELL
  '';
}
