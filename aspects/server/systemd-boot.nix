{ den, ... }:
{
  den.aspects.server.includes = [ den.aspects.server.systemd-boot ];

  den.aspects.server.systemd-boot = {
    nixos =
      { lib, ... }:
      {
        boot.loader = {
          systemd-boot = {
            enable = true;
            configurationLimit = lib.mkDefault 5;
          };

          timeout = lib.mkDefault 3;
          efi.canTouchEfiVariables = true;
        };
      };
  };
}
