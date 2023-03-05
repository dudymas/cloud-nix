{ goVersion ? 19
, system
, nixpkgs ? import <nixpkgs> { }
}:
let
  overlays = [ (self: import ./overlays { inherit goVersion; }) ];
  pkgs = import nixpkgs { inherit overlays system; };
in
import ./shell.nix { inherit pkgs; }
