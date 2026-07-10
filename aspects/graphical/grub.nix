{ den, ... }:
{
  den.aspects.graphical.includes = [ den.aspects.graphical.grub ];

  den.aspects.graphical.grub = {
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
