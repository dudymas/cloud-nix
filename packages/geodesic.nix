{ shell_name ? "geodesic"
, geodesic_distro ? "debian"
, version ? "1.8.0"

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
    inherit sha256;
    owner = "cloudposse";
    repo = "geodesic";
    rev = version;
  };

  # Our source is right where the unzip happens, not in a "src/" directory (default)
  sourceRoot = ".";

  installPhase = ''
    mkdir -p $out/etc
    mkdir -p $out/usr/local/bin
    mkdir -p $out/bin
    cp -r $src/rootfs/* $out
    cp -r $src/os/${geodesic_distro}/rootfs/* $out
    cat <<EOF > $out/bin/${shell_name}
    #!/bin/bash --norc
    exec bash --init-file /etc/profile
    EOF
    chmod +x $out/bin/${shell_name}
    for f in $( find $out -type f ); do
      substituteInPlace $f \
        --replace /usr/local/bin $out/usr/local/bin \
        --replace /etc/ $out/etc/
    done
  '';
}