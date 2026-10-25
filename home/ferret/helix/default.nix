{
  osConfig,
  lib,
  pkgs,
  ...
}:
let
  terminal = osConfig.desktop.terminal;
in
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

  xdg.desktopEntries."helix-terminal" = lib.mkIf (terminal != null) {
    name = "Helix (${terminal} window)";
    icon = "helix";
    exec = "${terminal} -e hx %F";
    type = "Application";
    noDisplay = true;
    terminal = false;
  };
}
