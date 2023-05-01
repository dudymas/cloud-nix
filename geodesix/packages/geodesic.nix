{ shell_name ? "geodesic"
, geodesic_distro ? "debian"
, version ? "1.8.0"
, owner ? "cloudposse"
, repo ? "geodesic"
, geodesic_scripts_to_exclude ? [ "docker" ]
, geodesic_base_dirs ? [ "rootfs" "os/${geodesic_distro}/rootfs" ]

, lib
, fetchurl
, stdenv
, sha256 ? "sha256-slVy+ZjpfU+1Empltw2aOGZKkkO6O9G5TaFIHVeYvV8="
, pkgs ? import <nixpkgs> {}
}:
stdenv.mkDerivation rec {
  bash = pkgs.bashInteractive;
  compdef = pkgs."bash-completion";
  direnv = pkgs.direnv;
  aws = pkgs.awscli2;
  yq = pkgs.yq-go;
  jq = pkgs.jq;
  tmux = pkgs.tmux;

  atmos = import ./atmos.nix { inherit pkgs; };
  terraform = import ./terraform.nix { inherit pkgs; };
  spacectl = import ./spacectl.nix { inherit pkgs; };
  kubectx = import ./k8s/kubectx.nix { inherit pkgs; };
  kubens = import ./k8s/kubens.nix { inherit pkgs; };
  helm = import ./k8s/helm.nix { inherit pkgs; };

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
    mkdir -p $out/bin
    for base_dir in ${builtins.concatStringsSep " " geodesic_base_dirs }; do
      pushd $src/$base_dir
      find * -type d -exec mkdir -p $out/{} \;
      find * -type f -exec cp {} $out/{} \;
      for script in ${builtins.concatStringsSep " " geodesic_scripts_to_exclude}; do
        find $out -type f -name $script -delete;
      done
      popd
    done

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
    for d in $aws $bash $atmos $terraform $yq $direnv $spacectl $tmux $kubectx $kubens $helm $jq; do
      find $d/bin -type f -exec ln -s {} $out \;
      pushd $d
        find bin/* -type f -exec ln -s $d/{} $out/{} \;
      popd
    done

    # patch the geodesic shell profile scripts
    cp -r $geodesix/profile.d $out/etc

    # generate geodesic shell
    cat > $out/bin/geodesic <<EOF
    #!/bin/bash
    export PATH=$out/bin:\$PATH
    exec bash --init-file $out/etc/profile "\$@"
    EOF
    chmod +x $out/bin/geodesic
  '';
}