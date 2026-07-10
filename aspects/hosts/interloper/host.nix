{ den, ... }:
{
  den.aspects.interloper = {
    includes = with den.aspects; [
      common
      server.zfs
    ];

    nixos = {
      networking.firewall.enable = false;

      services.zfs.autoScrub.enable = false;
    };
  };
}
