{
  description = "Cookiecutter : flake for templating projects";

  outputs =
    { self
    , flake-utils
    , mach-nix
    , nixpkgs
    , poetry2nix
    }:
    flake-utils.lib.eachDefaultSystem (system:
    let
      overlays = [
        (self: super: {
          machNix = mach-nix.defaultPackage.${system};
          python = super.python310;
        })
      ];

      pkgs = import nixpkgs { inherit overlays system; };
      
      project-templates-python = mach-nix.lib.${system}.mkPython {
        python = "python310";
        requirements = builtins.readFile ./requirements.txt;
      };

    in
    {
      devShells.default = pkgs.mkShell {
        packages = with pkgs; [ jq yq-go project-templates-python machNix shellcheck virtualenv ] ++
          (with pkgs.python310Packages; [ pip pre-commit pytest ]);
        shellHook = ''
          ${pkgs.python}/bin/python --version
        '';
      };
      apps = {
        cruft = {
          type = "app";
          program = "${project-templates-python}/bin/cruft";
        };
        pre-commit = {
          type = "app";
          program = "${project-templates-python}/bin/pre-commit";
        };
        pytest = {
          type = "app";
          program = "${project-templates-python}/bin/pytest";
        };
      };
    });
}
