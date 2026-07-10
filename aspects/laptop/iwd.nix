{ den, ... }:
{
  den.aspects.laptop.includes = [ den.aspects.laptop.iwd ];

  den.aspects.laptop.iwd = {
    nixos =
      { lib, ... }:
      {
        networking.wireless.iwd = {
          enable = true;
          settings.Network.EnableIPv6 = lib.mkDefault false;
        };

        networking.wireless.enable = false;

        networking.networkmanager.wifi = {
          backend = "iwd";
          powersave = true;
        };
      };
  };
}
