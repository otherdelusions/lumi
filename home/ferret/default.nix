{ pkgs, ... }:
{
  imports = [
    ./git.nix
    ./direnv.nix
    ./fish.nix
    ./starship.nix
    ./helix
    ./ssh.nix
  ];
  home = {
    username = "ferret";
    homeDirectory = "/home/ferret";
    stateVersion = "26.05";
    packages = [ pkgs.nurl ];
  };
  programs.home-manager.enable = true;
  programs.fish.enable = true;
}
