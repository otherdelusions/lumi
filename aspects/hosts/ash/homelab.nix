{ den, ... }:
{
  den.aspects.ash = {
    includes = with den.aspects.homelab.services; [
      avahi
      opencloud
    ];

    nixos =
      {
        config,
        lib,
        pkgs,
        ...
      }:
      let
        hl = config.homelab;
        mediaDirs = lib.unique (
          [ hl.dirs.content ] ++ lib.filter (lib.hasPrefix "${hl.dirs.content}/") hl.dirs.extra
        );
      in
      {
        systemd.tmpfiles.settings = {
          ash-homelab-base."${hl.dirs.content}".z = {
            mode = "2775";
            user = "root";
            inherit (hl) group;
          };
          ash-homelab-media = lib.genAttrs mediaDirs (_: {
            # force group-writable files
            "a+".argument = "u::rwx,g::rwx,o::rx,d:u::rwx,d:g::rwx,d:o::rx";
          });
        };

        security.nix-secrets.secrets = {
          "services/opencloud/ferret_pass" = {
            recipients = [ "ash" ];
            owner = config.services.opencloud.user;
          };
        };

        homelab = {
          baseDomain = "ash.local";
          dirs.content = "/mirror";
          dirs.extra = map (d: "${hl.dirs.content}/${d}") [
            "galleries"
            "galleries/default"
            "galleries/default/images"
            "galleries/default/videos"
            "galleries/extra"
            "galleries/extra/images"
            "galleries/extra/videos"
            "music"
            "manga"
            "manga/local"
            "manga/downloads"
          ];

          services.opencloud = {
            port = 4901;
            storageDir = "/srv/opencloud";
            environmentFile = config.security.nix-secrets.secrets."services/opencloud/ferret_pass".path;

            euroOffice = {
              enable = true;
              useMSFonts = true;
              port = 4902;
            };

            settings = {
              web.web.config.options = {
                disableSponsorLink = true;
                disableFeedbackLink = true;
              };

              frontend.archiver.max_size = 10737418240;

              storage-users.drivers.posix.personalspacepath_template = "users/{{.User.Username}}";
            };

            apps.calculator = pkgs.fetchzip {
              url = "https://github.com/opencloud-eu/web-extensions/releases/download/calculator-v2.1.0/calculator-2.1.0.zip";
              hash = "sha256-fm5r2THXdwklsEqblCbtBlWhzvUknQtGs0CoE9WFu1A=";
            };
          };
        };
      };
  };
}
