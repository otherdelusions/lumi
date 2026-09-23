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

      boot.initrd.availableKernelModules = [
        "xhci_pci"
        "ahci"
        "sd_mod"
      ];

      boot.kernelModules = [ "kvm-intel" ];

      boot.tmp.cleanOnBoot = true;

      boot.kernelParams = [
        "libata.force=noncq"
        "libata.noacpi=1"
      ];

      hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

      hardware.graphics.enable = true;

      hardware.graphics.extraPackages = with pkgs; [
        intel-media-driver
        intel-vaapi-driver
      ];

    };
}
