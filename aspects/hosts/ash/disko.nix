{ inputs, ... }:
{
  den.aspects.ash.nixos = {
    imports = [
      inputs.disko.nixosModules.disko
    ];

    disko.devices = {
      disk = {
        ssd = {
          device = "/dev/sdc";
          type = "disk";
          content = {
            type = "gpt";
            partitions = {
              ESP = {
                type = "EF00";
                size = "256M";
                content = {
                  type = "filesystem";
                  format = "vfat";
                  mountpoint = "/boot";
                  mountOptions = [ "umask=0077" ];
                };
              };
              root = {
                size = "100%";
                content = {
                  type = "filesystem";
                  format = "btrfs";
                  mountpoint = "/";
                };
              };
            };
          };
        };

        hdd1 = {
          type = "disk";
          device = "/dev/sda";
          content = {
            type = "gpt";
            partitions = {
              zfs = {
                size = "100%";
                content = {
                  type = "zfs";
                  pool = "mpool";
                };
              };
            };
          };
        };

        hdd2 = {
          type = "disk";
          device = "/dev/sdb";
          content = {
            type = "gpt";
            partitions = {
              zfs = {
                size = "100%";
                content = {
                  type = "zfs";
                  pool = "mpool";
                };
              };
            };
          };
        };
      };

      zpool = {
        mpool = {
          type = "zpool";
          mode = "mirror";
          options.cachefile = "none";
          options.ashift = "12";

          rootFsOptions = {
            compression = "lz4";
            atime = "off";
          };

          datasets = {
            data = {
              type = "zfs_fs";
              mountpoint = "/mirror";
              options = {
                mountpoint = "legacy";
                recordsize = "1M";
              };
            };
          };
        };
      };
    };
  };
}
