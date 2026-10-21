{ den, ... }:
{
  den.aspects.netsec.includes = [ den.aspects.netsec.dot ];

  den.aspects.netsec.dot = {
    nixos =
      { lib, ... }:
      {
        # stop NM from supplying DHCP DNS info
        networking.networkmanager = {
          dns = lib.mkForce "none";
          settings.main.systemd-resolved = false;
        };

        services.resolved = {
          enable = true;

          settings.Resolve = {
            DNS = [
              "9.9.9.9#dns.quad9.net"
              "149.112.112.112#dns.quad9.net"
            ];

            DNSOverTLS = "yes"; # no fallback to plain
            Domains = [ "~." ];
            FallbackDNS = "";
          };
        };
      };
  };
}
