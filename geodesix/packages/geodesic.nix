{ shell_name ? "geodesic"
, geodesic_distro ? "debian"
, version ? "1.8.0"
, owner ? "cloudposse"
, repo ? "geodesic"

, lib
, fetchurl
, stdenv
, sha256 ? "sha256-slVy+ZjpfU+1Empltw2aOGZKkkO6O9G5TaFIHVeYvV8="
, pkgs ? import <nixpkgs> {}
}:
stdenv.mkDerivation rec {
  bash = pkgs.bashInteractive;

  pname = "geodesic";
  url = "github:cloudposse/geodesic?ref=${version}";
  inherit version;

  src = pkgs.fetchFromGitHub {
    inherit sha256 owner repo;
    rev = version;
  };

  geodesix = ./..;

  packages = [];

  # Our source is right where the unzip happens, not in a "src/" directory (default)
  sourceRoot = ".";

  installPhase = ''
    mkdir -p $out/etc/profile.d
    mkdir -p $out/usr/local/bin
    mkdir -p $out/bin
    cp -r $src/rootfs/* $out
    cp -r $src/os/${geodesic_distro}/rootfs/* $out
    cp -r $geodesix/profile.d $out/etc
    rm $out/etc/profile.d/syslog-ng.sh
    for f in $( find $out -type f ); do
      substituteInPlace $f \
        --replace /usr/local/bin $out/usr/local/bin \
        --replace /etc/ $out/etc/ \
        --replace /localhost '$GEODESIC_LOCALHOST'
    done
    for b in $( find $out/usr/local/bin -type f ); do
      ln -s $b $out/bin/$( basename $b )
    done

  '';
}