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
        inherit (lib)
          mkOption
          literalExpression
          mkMerge
          mkDefault
          head
          ;

        inherit (lib.types)
          externalPath
          port
          attrsOf
          anything
          ;

        hl = config.homelab;
        cfg = hl.services.forgejo;
      in
      {
        options.homelab.services.forgejo = {
          dataDir = mkOption {
            type = externalPath;
            default = "${hl.dirs.data}/services/forgejo";
            example = "/var/lib/forgejo";
            description = "Forgejo data directory.";
          };

          repoDir = mkOption {
            type = externalPath;
            default = "${hl.dirs.content}/services/forgejo/repositories";
            example = "/srv/forgejo/repos";
            description = "Forgejo git repositories directory.";
          };

          port = mkOption {
            type = port;
            default = 3000;
            example = 9090;
            description = "Forgejo service port.";
          };

          settings = mkOption {
            type = attrsOf anything;
            default = { };
            example = literalExpression ''
              {
                server = {
                  DOMAIN = "forgejo.example.com";
                  ROOT_URL = "https://forgejo.example.com/";
                };

                lfs.ENABLED = true;
              }
            '';
            description = "Forgejo service settings.";
          };

          database = mkOption {
            type = attrsOf anything;
            default = { };
            example = literalExpression ''
              {
                type = "postgres";
                passwordFile = "/run/secrets/forgejo-postgres";
              }
            '';
            description = "Forgejo database settings.";
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
            inherit (cfg) database;

            settings = mkMerge [
              (mkDefault {
                server = {
                  DOMAIN = hl.baseDomain;
                  ROOT_URL = "http://${hl.baseDomain}:${toString cfg.port}/";
                  HTTP_ADDR = "0.0.0.0";
                  HTTP_PORT = cfg.port;
                  SSH_PORT = head config.services.openssh.ports;
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
