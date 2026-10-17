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
          homelab.services.forgejo.settings = {
            server = {
              DOMAIN = mkDefault hl.baseDomain;
              HTTP_ADDR = mkDefault "0.0.0.0";
              HTTP_PORT = mkDefault cfg.port;
              SSH_PORT = mkDefault (head config.services.openssh.ports);
            };
            service.DISABLE_REGISTRATION = mkDefault true;
            session.COOKIE_SECURE = mkDefault false;
          };

          networking.firewall.allowedTCPPorts = [ config.services.forgejo.settings.server.HTTP_PORT ];

          systemd.services.forgejo.unitConfig.RequiresMountsFor = [
            config.services.forgejo.stateDir
            config.services.forgejo.repositoryRoot
          ];

          services.forgejo = {
            enable = true;
            stateDir = cfg.dataDir;
            repositoryRoot = cfg.repoDir;

            inherit (cfg) database settings;
          };
        };
      };
  };
}
