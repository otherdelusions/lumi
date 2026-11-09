{
  pkgs,
  lib,
  ...
}:
{
  programs.fish = {
    enable = true;
    shellAliases = {
      ls = "ls -A --color=auto --group-directories-first";
      fastfetch = "${lib.getExe pkgs.fastfetch} --config neofetch";
    };

    interactiveShellInit = ''
      set -g fish_greeting
    '';
  };

  home.packages = [ pkgs.fish-lsp ];
}
