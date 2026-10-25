{ config, lib, ... }:
let
  cfg = config.services.forgejo;
in
{
  services.forgejo = {
    enable = true;
    stateDir = "/var/lib/homelab/services/forgejo";
    repositoryRoot = "/srv/forgejo/repositories";
    settings = {
      server = {
        DOMAIN = "${config.networking.hostName}.local";
        HTTP_ADDR = "0.0.0.0";
        HTTP_PORT = 3000;
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
