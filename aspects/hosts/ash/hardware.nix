{
  den.aspects.ash.nixos =
    {
      config,
      lib,
      modulesPath,
      ...
    }:

    {
      imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

      boot = {
        initrd.availableKernelModules = [
          "ahci"
          "xhci_pci"
          "usbhid"
          "usb_storage"
          "sd_mod"
        ];

        kernelModules = [ "kvm-intel" ];

        tmp.cleanOnBoot = true;
      };

      hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
    };
}
