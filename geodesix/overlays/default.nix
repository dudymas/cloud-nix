{ goVersion ? "18" }:
super: {
  go = super."go_1_${toString goVersion}";
  atmos = import ../packages/atmos.nix { pkgs = super; };
  terraform = import ../packages/terraform.nix { pkgs = super; };
  geodesic = super.callPackage (import ../packages/geodesic.nix) { pkgs = super; };
}