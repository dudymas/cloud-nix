{
  description = "cloud-nix : nix packages for cloud automation";

  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "github:NixOS/nixpkgs";

    # project-templates
    mach-nix.url = "github:/DavHau/mach-nix?ref=3.5.0";
  };

  outputs =
    { self
    , flake-utils
    , nixpkgs
    , mach-nix
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
      geodesix = import ./geodesix { inherit system nixpkgs; };

    in
    {
      devShells = {
        default = geodesix.shell;
        project-templates = import ./project-templates {
          inherit mach-nix pkgs system;
        };
        geodesix = geodesix.shell;
      };

      apps = {
        default = geodesix.app;
        geodesix = geodesix.app;
      };

    }) // {
      templates = {
        default = {
          path = ./nix-templates/geodesix;
          description = "Geodesix template for adding nix to your infra repo";
        };
        geodesix = {
          path = ./nix-templates/geodesix;
          description = "Geodesix template for adding nix to your infra repo";
        };
      };
    };
}
