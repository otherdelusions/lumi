{ pkgs, ... }:
{
  projectRootFile = "flake.nix";

  programs = {
    nixfmt.enable = true;
    deadnix.enable = true;
    statix.enable = true;
    yamlfmt.enable = true;
    actionlint.enable = true;
  };

  settings.formatter.markdownlint = {
    command = "${pkgs.markdownlint-cli}/bin/markdownlint";
    options = [
      "--fix"
      "--disable"
      "MD013"
      "MD033"
      "--"
    ];
    includes = [ "*.md" ];
  };
}
