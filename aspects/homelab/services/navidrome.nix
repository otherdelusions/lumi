{ den, ... }:
{
  flake.homelabServices.navidrome = {
    description = "music streaming server";
    iconUrl = "https://cdn.jsdelivr.net/gh/homarr-labs/dashboard-icons/png/navidrome.png";
    path = "aspects/homelab/services/navidrome.nix";
  };

  den.aspects.homelab.services.navidrome = {
    includes = [ den.aspects.homelab.services ];

    nixos =
      { config, lib, ... }:
      let
        hl = config.homelab;
        cfg = hl.services.navidrome;
      in
      {
        options.homelab.services.navidrome = {
          dataDir = lib.mkOption {
            type = lib.types.externalPath;
            default = "${hl.dirs.data}/services/navidrome";
            description = "Navidrome data directory";
          };

          musicDir = lib.mkOption {
            type = lib.types.externalPath;
            default = "${hl.dirs.content}/services/navidrome/music";
            description = "Navidrome music directory";
          };

          settings = lib.mkOption {
            type = lib.types.attrsOf lib.types.anything;
            default = { };
            description = "Navidrome settings";
          };
        };

        config = {
          systemd.services.navidrome.unitConfig.RequiresMountsFor = [
            (toString cfg.dataDir)
            (toString cfg.musicDir)
          ];

          services.navidrome = {
            enable = true;
            openFirewall = true;
            inherit (hl) user group;

            settings = lib.mkMerge [
              (lib.mkDefault {
                DataFolder = cfg.dataDir;
                MusicFolder = cfg.musicDir;
                Address = "0.0.0.0";
                DefaultDownsamplingFormat = "aac";
                EnableInsightsCollector = false;
              })

              cfg.settings
            ];
          };
        };
      };
  };
}
