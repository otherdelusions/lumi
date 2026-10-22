{ den, ... }:
{
  den.aspects.server.includes = [ den.aspects.server.zfs ];

  den.aspects.server.zfs.nixos =
    { pkgs, lib, ... }:
    {
      # fix hostId so we dont have to manually export zfs pools on live iso
      # for installed system to import (due to hostId mismatch)
      networking.hostId = lib.mkDefault "8425e349";

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
