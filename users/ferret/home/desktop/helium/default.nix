{
  inputs,
  self,
  pkgs,
  ...
}:
{
  imports = [
    self.homeManagerModules.helium
    ./preferences.nix
    ./flags.nix
  ];

  programs.helium = {
    enable = true;
    package = inputs.helium.packages.${pkgs.stdenv.hostPlatform.system}.default;
  };
}
