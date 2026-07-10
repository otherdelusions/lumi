{ den, ... }:
{
  den.aspects.laptop.includes = [ den.aspects.laptop.upower ];

  den.aspects.laptop.upower = {
    nixos = {
      services.upower.enable = true;
    };
  };
}
