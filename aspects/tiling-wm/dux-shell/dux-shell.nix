{ den, ... }:
{
  den.aspects.tiling-wm.includes = [ den.aspects.tiling-wm.dux-shell ];

  den.aspects.tiling-wm.dux-shell = {
    provides.to-users.homeManager =
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
          xdg.stateFile."dms/session.json" = lib.mkIf (cfg.session != { }) {
            source = jsonFormat.generate "session.json" cfg.session;
          };

          xdg.configFile."dms/settings.json" = lib.mkIf (cfg.settings != { }) {
            source = jsonFormat.generate "settings.json" cfg.settings;
          };
        };
      };

    nixos.programs.dux-shell.enable = true;
  };
}
