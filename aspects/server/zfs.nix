{ den, ... }:
{
  den.aspects.server.includes = [ den.aspects.server.zfs ];

  den.aspects.server.zfs.nixos =
    { pkgs, lib, ... }:
    {
      boot = {
        supportedFilesystems = [ "zfs" ];
        zfs = {
          package = pkgs.zfs_unstable;
          forceImportRoot = false;
        };
      };

      services.zfs = {
        autoScrub.enable = lib.mkDefault true;
        autoSnapshot.monthly = lib.mkDefault 1;
      };
    };
}
