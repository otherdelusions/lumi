{
  homelab,
  config,
  lib,
  ...
}:
let
  cfg = config.services.navidrome;
in
{
  services.navidrome = {
    enable = true;
    openFirewall = true;
    inherit (homelab) user group;

    settings = {
      DataFolder = "${homelab.dirs.data}/services/navidrome";
      MusicFolder = "${homelab.dirs.content}/music";
      Address = homelab.address;
      DefaultDownsamplingFormat = "aac";
      EnableInsightsCollector = false;
    };
  };

  systemd = {
    services.navidrome.unitConfig.RequiresMountsFor = [
      cfg.settings.DataFolder
      cfg.settings.MusicFolder
    ];

    # we manage those in base.nix
    tmpfiles.settings.navidromeDirs."${cfg.settings.MusicFolder}" = lib.mkForce { };
  };
}
