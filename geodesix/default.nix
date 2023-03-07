{ goVersion ? 19
, system
, nixpkgs
}:
let
  overlays = [ (self: import ./overlays { inherit goVersion; }) ];
  pkgs = import nixpkgs { inherit overlays system; };
in
{
  shell = import ./shell.nix { inherit pkgs; };
  app = {
    type = "app";
    program = "${pkgs.geodesic}/bin/geodesic";
  };
}
