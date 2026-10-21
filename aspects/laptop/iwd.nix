{ den, ... }:
{
  den.aspects.laptop.includes = [ den.aspects.laptop.iwd ];

  den.aspects.laptop.iwd = {
    nixos.networking.networkmanager.wifi = {
      backend = "iwd";
      powersave = true;
    };
  };
}
