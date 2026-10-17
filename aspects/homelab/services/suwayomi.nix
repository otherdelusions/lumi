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
          optional
          optionalAttrs
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
        serviceCfg = config.services.suwayomi-server;
        mediaDirs = [
          serviceCfg.settings.server.localSourcePath
        ]
        ++ optional (serviceCfg.settings.server ? downloadsPath) serviceCfg.settings.server.downloadsPath;
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
          homelab.services.suwayomi.settings = {
            port = mkDefault cfg.port;
            systemTrayEnabled = mkDefault false;
            initialOpenInBrowserEnabled = mkDefault false;
            backupInterval = mkDefault 0;
            globalUpdateInterval = mkDefault 0;
            authMode = mkDefault "NONE";
            opdsEnablePageReadProgress = mkDefault false;
          }
          // optionalAttrs (cfg.mangaDir != null) {
            downloadsPath = mkDefault "${cfg.mangaDir}/downloads";
            localSourcePath = mkDefault "${cfg.mangaDir}/local";
          };

          homelab.dirs.extra = [
            serviceCfg.dataDir
            "${serviceCfg.dataDir}/.local/share"
          ]
          ++ mediaDirs;

          services.suwayomi-server = {
            enable = true;
            openFirewall = true;

            inherit (hl) user group;
            inherit (cfg) dataDir;

            settings.server = cfg.settings;
          };

          systemd.services.suwayomi-server = {
            unitConfig.RequiresMountsFor = [ serviceCfg.dataDir ] ++ mediaDirs;

            environment = {
              HOME = serviceCfg.dataDir;
              JAVA_TOOL_OPTIONS = "-Duser.home=${serviceCfg.dataDir}";
            };

            serviceConfig = {
              ReadWritePaths = [ serviceCfg.dataDir ] ++ mediaDirs;
            };
          };
        };
      };
  };
}
