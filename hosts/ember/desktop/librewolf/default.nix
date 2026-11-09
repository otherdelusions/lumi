{ self, ... }:
{
  imports = [
    self.nixosModules.librewolf
    ./preferences.nix
    ./extensions.nix
    ./search.nix
  ];

  programs.librewolf.enable = true;
}
