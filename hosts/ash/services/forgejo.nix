{
  homelab,
  config,
  lib,
  ...
}:
let
  port = 4902;
  cfg = config.services.forgejo;
in
{
  services.forgejo = {
    enable = true;
    stateDir = "${homelab.dirs.data}/services/forgejo";
    repositoryRoot = "/srv/forgejo/repositories";

    settings = {
      server = {
        DOMAIN = homelab.baseDomain;
        HTTP_ADDR = homelab.address;
        HTTP_PORT = port;
        SSH_PORT = lib.head config.services.openssh.ports;
      };
      service.DISABLE_REGISTRATION = true;
      session.COOKIE_SECURE = false;
    };
  };

  networking.firewall.allowedTCPPorts = [ cfg.settings.server.HTTP_PORT ];

  systemd.services.forgejo.unitConfig.RequiresMountsFor = [
    cfg.stateDir
    cfg.repositoryRoot
  ];
}
