{ self, ... }:
{
  imports = [
    self.nixosModules.helium
    ./policies.nix
    ./extensions.nix
    ./search.nix
  ];

  programs.helium.enable = true;
}
