{ goVersion ? "18" }:
super: {
  go = super."go_1_${toString goVersion}";
  adr = super.callPackage ../packages/adr {};
  atmos = import ../packages/atmos.nix { pkgs = super; };
  termsvg = import ../packages/termsvg.nix { pkgs = super; };
  terraform = import ../packages/terraform.nix { pkgs = super; };
  spacectl = import ../packages/spacectl.nix { pkgs = super; };
  geodesic = super.callPackage (import ../packages/geodesic.nix) { pkgs = super; };
  updatecli = import ../packages/updatecli.nix { pkgs = super; };
}