{ system ? builtins.currentSystem
, pkgs ? import <nixpkgs> { }
}:
pkgs.mkShell {
  packages = with pkgs; [
    jq
    yq-go
    python3
    python3Packages.pip
    python3Packages.virtualenv
    ];
    shellHook = ''
      if [ ! -d .venv ]; then
        virtualenv .venv
      fi

      source .venv/bin/activate
      if ! which aider; then
        pip install aider-chat
      fi
    '';
}