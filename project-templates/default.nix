{ mach-nix
, system ? builtins.currentSystem
, pkgs ? import <nixpkgs> { }
}:
let
  project-templates-python = mach-nix.lib.${system}.mkPython {
    python = "python310";
    requirements = builtins.readFile ./requirements.txt;
  };
in
pkgs.mkShell {
  packages = with pkgs; [
    cookiecutter
    jq
    machNix
    shellcheck
    virtualenv
    yq-go
    ] ++ (with pkgs.python310Packages; [ pip pre-commit pytest ]);
  shellHook = ''
    ${pkgs.python}/bin/python --version
  '';
}
