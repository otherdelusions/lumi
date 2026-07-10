{ den, ... }:
{
  den.aspects.ash = {
    includes = with den.aspects; [
      common
      server
      dev
      homelab
    ];

    excludes = with den.aspects; [
      dev.starship
    ];

    nixos = {
      homelab.dirs.content = "/mirror";

      homelab.dirs.extra = [
        "/mirror/music"
      ];

      documentation.man.cache.enable = false;
    };
  };
}
