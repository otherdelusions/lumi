{ den, ... }:
{
  den.aspects.interloper = {
    includes = with den.aspects; [
      server.zfs
    ];

    nixos = {
      networking.firewall.enable = false;

      services.zfs.autoScrub.enable = false;
    };
  };
}
