{
  pkgs,
  lib,
  config,
  ...
}:
{
  programs.fish = {
    shellAliases = {
      ls = "ls -A --color=auto --group-directories-first";
      fastfetch = "${lib.getExe pkgs.fastfetch} --config neofetch";
    };

    interactiveShellInit = ''
      set -g fish_greeting
    '';
  };

  home.packages = lib.optional config.programs.fish.enable pkgs.fish-lsp;
}
