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
        inherit (lib)
          mkOption
          literalExpression
          mkMerge
          mkDefault
          ;

        inherit (lib.types)
          externalPath
          attrsOf
          anything
          ;

        hl = config.homelab;
        cfg = hl.services.navidrome;
      in
      {
        options.homelab.services.navidrome = {
          dataDir = mkOption {
            type = externalPath;
            default = "${hl.dirs.data}/services/navidrome";
            example = "/var/lib/navidrome";
            description = "Navidrome data directory.";
          };

          musicDir = mkOption {
            type = externalPath;
            default = "${hl.dirs.content}/services/navidrome/music";
            example = "/srv/navidrome/music";
            description = "Navidrome music directory.";
          };

          settings = mkOption {
            type = attrsOf anything;
            default = { };
            example = literalExpression ''
              {
                ScanSchedule = "@every 1h";
                Address = "127.0.0.1";
                Deezer.Enabled = false;
              }
            '';
            description = "Navidrome service settings.";
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

            settings = mkMerge [
              (mkDefault {
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
