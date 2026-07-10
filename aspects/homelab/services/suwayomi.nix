{ den, ... }:
{
  flake.homelabServices.suwayomi = {
    description = "\"manga\" reader";
    iconUrl = "https://raw.githubusercontent.com/Suwayomi/Suwayomi-Server/refs/heads/master/server/src/main/resources/icon/faviconlogo.png";
    path = "modules/homelab/services/suwayomi.nix";
  };

  den.aspects.homelab.services.suwayomi = {
    includes = [ den.aspects.homelab.services ];

    nixos =
      { config, lib, ... }:
      let
        hl = config.homelab;
        cfg = hl.services.suwayomi;
      in
      {
        options.homelab.services.suwayomi = {
          dataDir = lib.mkOption {
            type = lib.types.externalPath;
            default = "${hl.dirs.data}/services/suwayomi";
            description = "Suwayomi data directory";
          };

          mangaDir = lib.mkOption {
            type = lib.types.nullOr lib.types.externalPath;
            default = null;
            description = "Suwayomi manga directory";
          };

          port = lib.mkOption {
            type = lib.types.port;
            default = 8080;
            description = "Suwayomi port";
          };
        };

        config = {
          homelab.dirs.extra = [
            "${cfg.dataDir}"
            "${cfg.dataDir}/.local/share"
          ]
          ++ lib.optionals (cfg.mangaDir != null) [
            "${cfg.mangaDir}/local"
            "${cfg.mangaDir}/downloads"
          ];

          services.suwayomi-server = {
            enable = true;
            openFirewall = true;

            inherit (hl) user group;
            inherit (cfg) dataDir;

            settings.server = {
              port = lib.mkDefault cfg.port;
              systemTrayEnabled = lib.mkDefault false;
              initialOpenInBrowserEnabled = lib.mkDefault false;
              backupInterval = lib.mkDefault 0;
              globalUpdateInterval = lib.mkDefault 0;
              authMode = lib.mkDefault "NONE";
              opdsEnablePageReadProgress = lib.mkDefault false;

              downloadsPath = lib.mkIf (cfg.mangaDir != null) (
                lib.mkDefault "${toString cfg.mangaDir}/downloads"
              );
              localSourcePath = lib.mkIf (cfg.mangaDir != null) (lib.mkDefault "${toString cfg.mangaDir}/local");
            };
          };

          systemd.services.suwayomi-server = {
            unitConfig.RequiresMountsFor = [
              (toString cfg.dataDir)
            ]
            ++ lib.optional (cfg.mangaDir != null) (toString cfg.mangaDir);

            environment = {
              HOME = toString cfg.dataDir;
              JAVA_TOOL_OPTIONS = "-Duser.home=${toString cfg.dataDir}";
            };

            serviceConfig = {
              ReadWritePaths = [
                (toString cfg.dataDir)
              ]
              ++ lib.optional (cfg.mangaDir != null) (toString cfg.mangaDir);
            };
          };
        };
      };
  };
}
