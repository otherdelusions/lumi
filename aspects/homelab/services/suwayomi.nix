{ den, ... }:
{
  flake.homelabServices.suwayomi = {
    description = "\"manga\" reader";
    iconUrl = "https://raw.githubusercontent.com/Suwayomi/Suwayomi-Server/refs/heads/master/server/src/main/resources/icon/faviconlogo.png";
    path = "aspects/homelab/services/suwayomi.nix";
  };

  den.aspects.homelab.services.suwayomi = {
    includes = [ den.aspects.homelab.services ];

    nixos =
      { config, lib, ... }:
      let
        inherit (lib)
          mkOption
          literalExpression
          optionals
          optionalAttrs
          mkMerge
          mkDefault
          ;

        inherit (lib.types)
          externalPath
          nullOr
          port
          attrsOf
          anything
          ;

        hl = config.homelab;
        cfg = hl.services.suwayomi;
      in
      {
        options.homelab.services.suwayomi = {
          dataDir = mkOption {
            type = externalPath;
            default = "${hl.dirs.data}/services/suwayomi";
            example = "/var/lib/suwayomi";
            description = "Suwayomi data directory.";
          };

          mangaDir = mkOption {
            type = nullOr externalPath;
            default = null;
            example = "/srv/manga";
            description = "Suwayomi manga directory.";
          };

          port = mkOption {
            type = port;
            default = 8080;
            example = 9090;
            description = "Suwayomi service port.";
          };

          settings = mkOption {
            type = attrsOf anything;
            default = { };
            example = literalExpression ''
              {
                maxLogFiles = 31;
                webUIEnabled = true;
                webUIInterface = "browser";
                socksProxyEnabled = false;
              }
            '';
            description = "Suwayomi 'server' section settings.";
          };
        };

        config = {
          homelab.dirs.extra = [
            "${cfg.dataDir}"
            "${cfg.dataDir}/.local/share"
          ]
          ++ optionals (cfg.mangaDir != null) [
            "${cfg.mangaDir}/local"
            "${cfg.mangaDir}/downloads"
          ];

          services.suwayomi-server = {
            enable = true;
            openFirewall = true;

            inherit (hl) user group;
            inherit (cfg) dataDir;

            settings = mkMerge [
              (mkDefault {
                server = {
                  inherit (cfg) port;
                  systemTrayEnabled = false;
                  initialOpenInBrowserEnabled = false;
                  backupInterval = 0;
                  globalUpdateInterval = 0;
                  authMode = "NONE";
                  opdsEnablePageReadProgress = false;
                }
                // optionalAttrs (cfg.mangaDir != null) {
                  downloadsPath = "${cfg.mangaDir}/downloads";
                  localSourcePath = "${cfg.mangaDir}/local";
                };
              })
              cfg.settings
            ];
          };

          systemd.services.suwayomi-server = {
            unitConfig.RequiresMountsFor = [
              "${cfg.dataDir}"
            ]
            ++ optionals (cfg.mangaDir != null) [ "${cfg.mangaDir}" ];

            environment = {
              HOME = cfg.dataDir;
              JAVA_TOOL_OPTIONS = "-Duser.home=${cfg.dataDir}";
            };

            serviceConfig = {
              ReadWritePaths = [
                "${cfg.dataDir}"
              ]
              ++ optionals (cfg.mangaDir != null) [ "${cfg.mangaDir}" ];
            };
          };
        };
      };
  };
}
