{
  description = "Cookiecutter : flake for templating projects";

  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "github:NixOS/nixpkgs";

    # project-templates
    mach-nix.url = "github:/DavHau/mach-nix?ref=3.5.0";
    poetry2nix.url = "github:nix-community/poetry2nix";
    
    # geodesix
  };

  outputs =
    { self
    , flake-utils
    , nixpkgs
    }:
    flake-utils.lib.eachDefaultSystem (system:
    let
      overlays = [ ];

      pkgs = import nixpkgs { inherit overlays system; };

    in
    {
      devShells = {
        default = pkgs.mkShell {
          packages = with pkgs; [ jq yq-go ];
        };
        project-templates = import ./project-templates { inherit pkgs; };
      };
      apps = { };
      templates = {
        geodesix = {
          path = ./templates/geodesix;
          description = "Geodesix template for adding nix to your infra repo";
        };
      };
    });
}
