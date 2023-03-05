{
  description = "Cookiecutter : flake for templating projects";

  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "github:NixOS/nixpkgs";
  };

  outputs =
    { self
    , flake-utils
    , nixpkgs
    }:
    flake-utils.lib.eachDefaultSystem (system:
    let
      overlays = [];

      pkgs = import nixpkgs { inherit overlays system; };

    in
    {
      devShells.default = pkgs.mkShell {
        packages = with pkgs; [ jq yq-go ];
      };
      apps = {};
    });
}
