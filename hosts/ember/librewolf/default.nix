{
  imports = [
    ../../../modules/librewolf.nix
    ./preferences.nix
    ./extensions.nix
    ./search.nix
  ];

  programs.librewolf.enable = true;
}
