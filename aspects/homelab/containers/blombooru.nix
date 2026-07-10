{ den, ... }:
{
  flake.homelabContainers.blombooru = {
    description = "single-user taggable image board";
    iconUrl = "https://raw.githubusercontent.com/mrblomblo/blombooru/refs/heads/main/frontend/static/images/pwa-icon.png";
    path = "aspects/homelab/containers/blombooru.nix";
  };

  den.aspects.homelab.containers.blombooru = {
    includes = [ den.aspects.homelab.containers ];

    nixos =
      {
        config,
        lib,
        pkgs,
        ...
      }:
      let
        hl = config.homelab;
        cfg = hl.containers.blombooru;
      in
      {
        options.homelab.containers.blombooru = {
          dataDir = lib.mkOption {
            type = lib.types.externalPath;
            default = "${hl.dirs.data}/containers/blombooru";
            description = "Blombooru base data directory";
          };

          mediaDir = lib.mkOption {
            type = lib.types.externalPath;
            default = "${hl.dirs.content}/containers/blombooru/media";
            description = "Blombooru media directory";
          };

          port = lib.mkOption {
            type = lib.types.port;
            default = 8100;
            description = "Blombooru port";
          };

          settings = lib.mkOption {
            type = lib.types.attrsOf lib.types.anything;
            default = { };
            description = "Blombooru settings";
          };

          postgres = {
            user = lib.mkOption {
              type = lib.types.str;
              default = "blombooru";
            };
            dbname = lib.mkOption {
              type = lib.types.str;
              default = "blombooru";
            };
            environmentFile = lib.mkOption {
              type = lib.types.externalPath;
              description = "Environment file providing POSTGRES_PASSWORD";
            };
          };

          redis.environmentFile = lib.mkOption {
            type = lib.types.externalPath;
            description = "Environment file providing REDIS_PASSWORD";
          };
        };

        config =
          let
            bbId = "1000";
            settings = lib.recursiveUpdate {
              database = {
                host = "blombooru-postgres";
                port = 5432;
                name = cfg.postgres.dbname;
                user = cfg.postgres.user;
              };
              redis = {
                host = "blombooru-redis";
                port = 6379;
                enabled = true;
              };
            } cfg.settings;

            settingsFile = (pkgs.formats.json { }).generate "blombooru-settings.json" settings;
          in
          {
            networking.firewall.allowedTCPPorts = [ cfg.port ];

            homelab.dirs.extra = [
              "${cfg.dataDir}"
              "${cfg.dataDir}/postgres"
              "${cfg.dataDir}/redis"
            ];

            systemd.tmpfiles.rules = [
              "d ${cfg.dataDir}/data 0755 ${bbId} ${bbId} -"
              "d ${cfg.mediaDir} 2755 ${bbId} ${bbId} -"
              "d ${cfg.dataDir}/cache 0755 ${bbId} ${bbId} -"
              "d ${cfg.dataDir}/thumbnails 0755 ${bbId} ${bbId} -"

              "C ${cfg.dataDir}/data/settings.json 0644 ${bbId} ${bbId} - ${settingsFile}"
            ];

            systemd.services.podman-blombooru.unitConfig.RequiresMountsFor = [
              (toString cfg.dataDir)
              (toString cfg.mediaDir)
            ];

            virtualisation.oci-containers.containers = {
              blombooru-postgres = {
                image = "postgres:17";
                autoStart = true;
                environment = {
                  POSTGRES_USER = cfg.postgres.user;
                  POSTGRES_DB = cfg.postgres.dbname;
                };
                environmentFiles = [ cfg.postgres.environmentFile ];
                volumes = [
                  "${cfg.dataDir}/postgres:/var/lib/postgresql/data"
                ];
              };

              blombooru-redis = {
                image = "redis:7-alpine";
                autoStart = true;
                environmentFiles = [ cfg.redis.environmentFile ];
                cmd = [
                  "sh"
                  "-c"
                  "redis-server --save 60 1 --loglevel warning --requirepass \"$REDIS_PASSWORD\""
                ];
                volumes = [
                  "${cfg.dataDir}/redis:/data"
                ];
              };

              blombooru = {
                image = "ghcr.io/mrblomblo/blombooru:latest";
                autoStart = true;
                dependsOn = [
                  "blombooru-postgres"
                  "blombooru-redis"
                ];
                ports = [ "${toString cfg.port}:8000" ];
                environment.UVICORN_PORT = "8000";
                environmentFiles = [
                  cfg.postgres.environmentFile
                  cfg.redis.environmentFile
                ];
                volumes = [
                  "${cfg.mediaDir}:/app/media/original"
                  "${cfg.dataDir}/cache:/app/media/cache"
                  "${cfg.dataDir}/thumbnails:/app/media/thumbnails"
                  "${cfg.dataDir}/data:/app/data"
                ];
              };
            };
          };
      };
  };
}
