{ den, ... }:
{
  den.aspects.ash = {
    includes = with den.aspects.homelab.services; [
      avahi
    ];

    nixos =
      { config, lib, ... }:
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
        };
      };
  };
}
