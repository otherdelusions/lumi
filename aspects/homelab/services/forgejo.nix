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

            settings = {
              server = {
                DOMAIN = lib.mkDefault hl.baseDomain;
                ROOT_URL = lib.mkDefault "http://${hl.baseDomain}:${toString cfg.port}/";
                HTTP_ADDR = lib.mkDefault "0.0.0.0";
                HTTP_PORT = lib.mkDefault cfg.port;
                SSH_PORT = lib.mkDefault (lib.head config.services.openssh.ports);
              };
              service.DISABLE_REGISTRATION = lib.mkDefault true;
              session.COOKIE_SECURE = lib.mkDefault false;
            };
          };
        };
      };
  };
}
