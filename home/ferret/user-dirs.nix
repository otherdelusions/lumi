{ lib, config, ... }:
{
  xdg.userDirs.enable = lib.mkDefault true;
  xdg.userDirs.setSessionVariables = lib.mkDefault true;

  home.file =
    let
      inherit (config.xdg.userDirs) templates;
    in
    lib.optionalAttrs (config.xdg.userDirs.enable && templates != null) {
      "${templates}/Empty Text.txt".text = "";
    };
}
