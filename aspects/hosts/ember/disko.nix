{ inputs, ... }:
{
  den.aspects.ember.nixos = {
    imports = [
      inputs.disko.nixosModules.disko
    ];

    disko.devices = {
      disk = {
        main = {
          device = "/dev/disk/by-id/ata-INTEL_SSDSC2KB960G8_BTYF9161070D960CGN";
          type = "disk";
          content = {
            type = "gpt";
            partitions = {

              MBR = {
                size = "1M";
                type = "EF02";
                attributes = [ 0 ];
              };

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

              swap = {
                size = "24G";
                content = {
                  type = "swap";
                  discardPolicy = "both";
                  resumeDevice = true;
                };
              };

              root = {
                size = "100%";
                content = {
                  type = "filesystem";
                  format = "btrfs";
                  mountpoint = "/";
                  mountOptions = [ "noatime" ];
                };
              };

            };
          };
        };
      };
    };
  };
}
