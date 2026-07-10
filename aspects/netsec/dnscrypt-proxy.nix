{ den, ... }:
{
  den.aspects.netsec.includes = [ den.aspects.netsec.dnscrypt-proxy ];

  den.aspects.netsec.dnscrypt-proxy = {
    nixos =
      { lib, config, ... }:
      {
        services.dnscrypt-proxy = {
          enable = true;

          settings = {
            sources.public-resolvers = {
              urls = [
                "https://raw.githubusercontent.com/DNSCrypt/dnscrypt-resolvers/master/v3/public-resolvers.md"
                "https://download.dnscrypt.info/resolvers-list/v3/public-resolvers.md"
              ];
              minisign_key = "RWQf6LRCGA9i53mlYecO4IzT51TGPpvWucNSCh1CBM0QTaLn73Y7GFO3";
              cache_file = "/var/lib/dnscrypt-proxy/public-resolvers.md";
            };

            ipv6_servers = false;
            block_ipv6 = true;

            require_dnssec = true;
            require_nolog = true;
            require_nofilter = true;
          };
        };

        systemd.services = lib.mkIf config.services.dnscrypt-proxy.enable {
          dnscrypt-proxy.serviceConfig.StateDirectory = "dnscrypt-proxy";
        };

        networking = lib.mkIf config.services.dnscrypt-proxy.enable {
          nameservers = [ "127.0.0.1" ];
          dhcpcd.enable = false;
          useDHCP = false;
          networkmanager.dns = "none";
        };
      };
  };
}
