{ den, ... }:
{
  den.aspects.tiling-wm.includes = [ den.aspects.tiling-wm.dms-shell ];

  den.aspects.tiling-wm.dms-shell = {
    homeManager =
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

        imports = [
          # aliases for those who think we still use dms module
          (lib.mkAliasOptionModule
            [ "programs" "dank-material-shell" "settings" ]
            [ "programs" "dms-shell" "settings" ]
          )
          (lib.mkAliasOptionModule
            [ "programs" "dank-material-shell" "session" ]
            [ "programs" "dms-shell" "session" ]
          )
        ];

        config = {
          xdg.stateFile."DankMaterialShell/session.json" = lib.mkIf (cfg.session != { }) {
            source = jsonFormat.generate "session.json" cfg.session;
          };

          xdg.configFile."DankMaterialShell/settings.json" = lib.mkIf (cfg.settings != { }) {
            source = jsonFormat.generate "settings.json" cfg.settings;
          };
        };
      };

    nixos = { host, ... }: {
      programs.dms-shell = {
        enable = host.desktop.compositor != null;

        systemd = {
          enable = true;
          restartIfChanged = true;
        };

        enableCalendarEvents = false;
        enableDynamicTheming = false;
        enableClipboardPaste = false;
        enableVPN = false;
      };
    };
  };
}
