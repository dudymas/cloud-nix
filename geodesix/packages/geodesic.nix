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
  meta = {
    mainProgram = "geodesic";
  };

  src = pkgs.fetchFromGitHub {
    inherit sha256 owner repo;
    rev = version;
  };

  geodesix = ./..;

  # Our source is right where the unzip happens, not in a "src/" directory (default)
  sourceRoot = ".";

  installPhase = ''
    # init
    mkdir -p $out/etc/profile.d
    mkdir -p $out/usr/local/bin
    mkdir -p $out/bin

    # copy geodesic source
    cp -r $src/rootfs/* $out
    cp -r $src/os/${geodesic_distro}/rootfs/* $out

    # clean up any unnecessary files
    rm $out/etc/profile.d/syslog-ng.sh

    # nixify the geodesic shell
    for f in $( find $out -type f ); do
      substituteInPlace $f \
        --replace /usr/local/bin $out/usr/local/bin \
        --replace /etc/ $out/etc/ \
        --replace /localhost '$GEODESIC_LOCALHOST'
    done

    # link binaries to /bin
    for b in $( find $out/usr/local/bin -type f ); do
      ln -s $b $out/bin/$( basename $b )
    done

    # patch the geodesic shell profile scripts
    cp -r $geodesix/profile.d $out/etc

    # generate geodesic shell
    cat > $out/bin/geodesic <<EOF
    #!/usr/bin/env bash
    exec ${bash}/bin/bash --init-file $out/etc/profile $@
    EOF
    chmod +x $out/bin/geodesic
  '';
}