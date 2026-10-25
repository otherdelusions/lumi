{ lib, ... }:
{
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;

    config.global.log_filter = lib.mkDefault "loading|using|nix-direnv|execute";
  };
}
