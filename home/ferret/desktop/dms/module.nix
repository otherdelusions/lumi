{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.programs.dms-shell;
  jsonFormat = pkgs.formats.json { };
in
{
  options.programs.dms-shell = {
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
    xdg.stateFile."DankMaterialShell/session.json" = lib.mkIf (cfg.session != { }) {
      source = jsonFormat.generate "session.json" cfg.session;
    };

    xdg.configFile."DankMaterialShell/settings.json" = lib.mkIf (cfg.settings != { }) {
      source = jsonFormat.generate "settings.json" cfg.settings;
    };
  };
}
