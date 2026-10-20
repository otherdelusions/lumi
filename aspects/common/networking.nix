{ den, ... }:
{
  den.aspects.common.includes = [ den.aspects.common.networking ];

  den.aspects.common.networking = {
    nixos =
      { host, lib, ... }:
      {
        networking.hostId = lib.substring 0 8 (lib.hashString "sha256" host.name);

        networking.firewall = {
          enable = lib.mkDefault true;
          logRefusedConnections = lib.mkDefault false;
          allowPing = true;
        };

        systemd = {
          network.wait-online.enable = false;
          services = {
            NetworkManager-wait-online.enable = false;
            systemd-networkd.stopIfChanged = false;
          };
        };
      };
  };
}
