{
  description = "A Nix-flake-based Go development environment";

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
      goVersion = 19;
      overlays = [ (self: import ./overlays { inherit goVersion; }) ];
      pkgs = import nixpkgs { inherit overlays system; };
    in
    {
      devShells.default = import ./shell.nix { inherit pkgs; };
    });
}
