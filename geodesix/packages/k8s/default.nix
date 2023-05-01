{
  overlay = 
    super: {
      kubectx = import ./kubectx.nix { pkgs = super; };
      kubens = import ./kubens.nix { pkgs = super; };
    };
  packages = {
    kubectx = import ./kubectx.nix;
    kubens = import ./kubens.nix;
  };
}