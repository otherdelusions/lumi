{
  inputs,
  config,
  lib,
  ...
}:
let
  cfg = config.services.copyparty;
in
{
  imports = [ inputs.copyparty.nixosModules.default ];
  services.copyparty = {
    enable = true;
    user = "homelab";
    group = "homelab";
    settings = {
      p = 3210;
      i = "0.0.0.0";
      e2dsa = true;
      e2tsr = true;
      e2vu = true;
      z = true;
      no-reload = true;
      localtime = true;
      rotf-tz = config.time.timeZone;
      hist = "/var/lib/homelab/services/copyparty";
      chmod-f = "664";
      chmod-d = "775";
    };
    # Configure account password files and volume access before enabling.
    volumes."/".path = "/mirror";
  };
  systemd.services.copyparty.unitConfig.RequiresMountsFor =
    lib.mapAttrsToList (_: volume: volume.path) cfg.volumes
    ++ [ cfg.settings.hist ];
  systemd.tmpfiles.settings.copyparty-history."${cfg.settings.hist}".d = {
    mode = "0750";
    inherit (cfg) user group;
  };
  # Open the configured port here when remote access is ready.
}
