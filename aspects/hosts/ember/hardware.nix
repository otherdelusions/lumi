{
  den.aspects.ember.nixos =
    {
      config,
      lib,
      modulesPath,
      pkgs,
      ...
    }:

    {
      imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

      boot = {
        initrd.availableKernelModules = [
          "xhci_pci"
          "ahci"
          "sd_mod"
        ];

        kernelModules = [ "kvm-intel" ];

        tmp.cleanOnBoot = true;

        kernelParams = [
          "libata.force=noncq"
          "libata.noacpi=1"
        ];
      };

      hardware = {
        cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
        graphics = {
          enable = true;
          extraPackages = with pkgs; [
            intel-media-driver
            intel-vaapi-driver
          ];
        };
      };
    };
}
