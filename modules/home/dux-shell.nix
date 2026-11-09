{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.programs.dux-shell;
  jsonFormat = pkgs.formats.json { };
in
{
  options.programs.dux-shell = {
    settings = lib.mkOption {
      inherit (jsonFormat) type;
      default = { };
      description = "dms settings";
    };
    session = lib.mkOption {
      inherit (jsonFormat) type;
      default = { };
      description = "dms session";
    };
  };

  config = {
    xdg.stateFile."dms/session.json" = {
      source = jsonFormat.generate "session.json" cfg.session;
    };

    xdg.configFile."dms/settings.json" = {
      source = jsonFormat.generate "settings.json" cfg.settings;
    };
  };
}
