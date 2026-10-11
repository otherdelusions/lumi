{ den, ... }:
{
  den.aspects.netsec.includes = [ den.aspects.netsec.dnscrypt-proxy ];

  den.aspects.netsec.dnscrypt-proxy = {
    nixos =
      { lib, config, ... }:
      let
        StateDirectory = "dnscrypt-proxy";
      in
      {
        services.dnscrypt-proxy = {
          enable = true;

          settings = {
            listen_addresses = [ "127.0.0.1:53" ];

            ipv6_servers = false;
            block_ipv6 = true;

            dnscrypt_servers = true;
            doh_servers = false;
            odoh_servers = false;

            require_nolog = false;
            require_dnssec = true;
            require_nofilter = true;

            server_names = [ ];

            disabled_server_names = [
              "cs-fr"
              "scaleway-ams"
            ];

            bootstrap_resolvers = [
              "9.9.9.11:53"
              "8.8.8.8:53"
            ];
            ignore_system_dns = true;

            cache = true;
            cache_size = 4096;

            anonymized_dns = {
              routes = [
                {
                  server_name = "*";
                  via = [
                    "anon-cs-fr"
                    "anon-scaleway-ams"
                  ];
                }
              ];

              skip_incompatible = true;
              direct_cert_fallback = true;
            };

            sources.public-resolvers = {
              urls = [
                "https://raw.githubusercontent.com/DNSCrypt/dnscrypt-resolvers/master/v3/public-resolvers.md"
                "https://download.dnscrypt.info/resolvers-list/v3/public-resolvers.md"
                "https://cdn.jsdelivr.net/gh/DNSCrypt/dnscrypt-resolvers@master/v3/public-resolvers.md"
              ];
              cache_file = "/var/lib/${StateDirectory}/public-resolvers.md";
              minisign_key = "RWQf6LRCGA9i53mlYecO4IzT51TGPpvWucNSCh1CBM0QTaLn73Y7GFO3";
              refresh_delay = 73;
              prefix = "";
            };

            sources.relays = {
              urls = [
                "https://raw.githubusercontent.com/DNSCrypt/dnscrypt-resolvers/master/v3/relays.md"
                "https://download.dnscrypt.info/resolvers-list/v3/relays.md"
                "https://cdn.jsdelivr.net/gh/DNSCrypt/dnscrypt-resolvers@master/v3/relays.md"
              ];
              cache_file = "/var/lib/${StateDirectory}/relays.md";
              minisign_key = "RWQf6LRCGA9i53mlYecO4IzT51TGPpvWucNSCh1CBM0QTaLn73Y7GFO3";
              refresh_delay = 73;
              prefix = "";
            };
          };
        };

        systemd.services.dnscrypt-proxy.serviceConfig.StateDirectory = StateDirectory;

        services.resolved.enable = !config.services.dnscrypt-proxy.enable;

        networking = lib.mkIf config.services.dnscrypt-proxy.enable {
          nameservers = [ "127.0.0.1" ];
          dhcpcd.enable = false;
          useDHCP = false;
          networkmanager.dns = "none";
        };
      };
  };
}
