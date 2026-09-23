{ den, ... }:
{
  den.aspects.tiling-wm.includes = [ den.aspects.tiling-wm.grub ];

  den.aspects.tiling-wm.grub = {
    nixos =
      { lib, ... }:
      {
        boot.loader = {
          grub = {
            enable = true;
            efiSupport = true;
            configurationLimit = lib.mkDefault 5;
            device = "nodev";
            timeoutStyle = lib.mkDefault "hidden";
          };

          timeout = lib.mkDefault 0;
          efi.canTouchEfiVariables = true;
        };
      };
  };
}
