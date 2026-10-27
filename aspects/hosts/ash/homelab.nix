{ den, ... }:
{
  den.aspects.ash = {
    includes = with den.aspects.homelab.services; [
      avahi
      copyparty
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
        copypartyTheme =
          pkgs.runCommand "copyparty-drive-theme.html"
            {
              src = pkgs.fetchurl {
                url = "https://raw.githubusercontent.com/Ransomwave/copyparty-drive-theme/590dc959bb42b66ace74b451d0ba8a919f0f66cb/drive.css";
                hash = "sha256-RY/C55mQ0RzYEgyTBah844TMNvQB3A0L1wlivWA0CLQ=";
              };
            }
            ''
              echo '<style>' > "$out"
              cat "$src" >> "$out"
              echo '</style>' >> "$out"
            '';
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
          "services/copyparty/ferret_pass" = {
            recipients = [ "ash" ];
            owner = "homelab";
          };
        };

        homelab = {
          baseDomain = "ash.local";
          dirs.content = "/mirror";
          dirs.extra = map (d: "${hl.dirs.content}/${d}") [
            "library"
            "library/inbox"
            "library/gallery"
            "library/gallery/images"
            "library/gallery/videos"
            "library/music"
            "library/extra"
            "library/extra/gallery"
            "library/extra/gallery/images"
            "library/extra/gallery/videos"
            "library/extra/manga"
            "library/extra/manga/local"
            "library/extra/manga/downloads"
            "shared"
          ];

          services.copyparty = {
            port = 4901;
            openFirewall = true;
            settings = {
              xvol = true;
              html-head = "@${copypartyTheme}";
              ui-filesz = 3;
            };

            accounts.ferret.passwordFile =
              config.security.nix-secrets.secrets."services/copyparty/ferret_pass".path;

            volumes."/" = {
              path = hl.dirs.content;
              access.A = "ferret";
              flags.scan = 60;
            };
          };
        };
      };
  };
}
