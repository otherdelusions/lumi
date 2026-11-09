{ self, ... }:
{
  imports = [
    self.homeManagerModules.dux-shell
    ./settings.nix
    ./niri.nix
  ];
}
