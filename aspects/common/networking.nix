{ den, ... }:
{
  den.aspects.common.includes = [ den.aspects.common.networking ];

  den.aspects.common.networking = {
    nixos =
      { lib, ... }:
      {
        networking.firewall = {
          enable = lib.mkDefault true;
          logRefusedConnections = lib.mkDefault false;
          allowPing = true;
        };
      };
  };
}
