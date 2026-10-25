{ config, lib, ... }:
let
  cfg = config.services.navidrome;
in
{
  services.navidrome = {
    enable = true;
    openFirewall = true;
    user = "homelab";
    group = "homelab";
    settings = {
      DataFolder = "/var/lib/homelab/services/navidrome";
      MusicFolder = "/mirror/music";
      Address = "0.0.0.0";
      DefaultDownsamplingFormat = "aac";
      EnableInsightsCollector = false;
    };
  };
  systemd = {
    services.navidrome.unitConfig.RequiresMountsFor = [
      cfg.settings.DataFolder
      cfg.settings.MusicFolder
    ];
    tmpfiles.settings = {
      # The upstream module otherwise removes shared group write permissions.
      navidromeDirs."${cfg.settings.MusicFolder}" = lib.mkForce { };
      navidrome-media."${cfg.settings.MusicFolder}" = {
        d = {
          mode = "2775";
          inherit (cfg) user group;
        };
        "a+".argument = "u::rwx,g::rwx,o::rx,d:u::rwx,d:g::rwx,d:o::rx";
      };
    };
  };
}
