{ pkgs, ... }:
{
  imports = [
    ./settings.nix
    ./languages.nix
  ];

  programs.helix = {
    enable = true;
    package = pkgs.steelix;
    defaultEditor = true;

    extraPackages = with pkgs; [
      nixd
      nixfmt
    ];
  };
}
