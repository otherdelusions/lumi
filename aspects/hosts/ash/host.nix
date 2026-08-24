{ den, ... }:
{
  den.aspects.ash = {
    includes = with den.aspects; [
      server
      dev
      homelab
    ];

    nixos = {
      documentation.man.cache.enable = false;
    };
  };
}
