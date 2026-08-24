{ den, ... }:
{
  flake.homelabServices.forgejo = {
    description = "self-hosted git forge";
    iconUrl = "https://cdn.jsdelivr.net/gh/homarr-labs/dashboard-icons/png/forgejo.png";
    path = "aspects/homelab/services/forgejo.nix";
  };

  den.aspects.homelab.services.forgejo = {
    includes = [ den.aspects.homelab.services ];

    nixos =
      { config, lib, ... }:
      let
        hl = config.homelab;
        cfg = hl.services.forgejo;
      in
      {
        options.homelab.services.forgejo = {
          dataDir = lib.mkOption {
            type = lib.types.externalPath;
            default = "${hl.dirs.data}/services/forgejo";
            description = "Forgejo data directory";
          };

          repoDir = lib.mkOption {
            type = lib.types.externalPath;
            default = "${hl.dirs.content}/services/forgejo/repositories";
            description = "Forgejo git repository directory";
          };

          port = lib.mkOption {
            type = lib.types.port;
            default = 3000;
            description = "Forgejo port";
          };

          settings = lib.mkOption {
            type = lib.types.attrsOf lib.types.anything;
            default = { };
            description = "Forgejo settings";
          };
        };

        config = {
          networking.firewall.allowedTCPPorts = [ cfg.port ];

          systemd.services.forgejo.unitConfig.RequiresMountsFor = [
            (toString cfg.dataDir)
            (toString cfg.repoDir)
          ];

          services.forgejo = {
            enable = true;
            stateDir = cfg.dataDir;
            repositoryRoot = cfg.repoDir;
            inherit (hl) user group;

            database.type = "sqlite3";

            settings = lib.mkMerge [
              (lib.mkDefault {
                server = {
                  DOMAIN = hl.baseDomain;
                  ROOT_URL = "http://${hl.baseDomain}:${toString cfg.port}/";
                  HTTP_ADDR = "0.0.0.0";
                  HTTP_PORT = cfg.port;
                  SSH_PORT = lib.head config.services.openssh.ports;
                };
                service.DISABLE_REGISTRATION = true;
                session.COOKIE_SECURE = false;
              })

              cfg.settings
            ];
          };
        };
      };
  };
}
