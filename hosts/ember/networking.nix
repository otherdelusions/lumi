{ lib, self, ... }:
{
  imports = [
    self.nixosModules.zapret
    ./tls.nix
  ];

  networking = {
    enableIPv6 = false;
    firewall.allowedUDPPorts = [ 5353 ];
    firewall.trustedInterfaces = [ "Meta" ];
    networkmanager = {
      enable = true;

      # Stop NetworkManager from supplying DHCP DNS information.
      dns = lib.mkForce "none";
      settings.main.systemd-resolved = false;
    };
  };

  systemd.services.NetworkManager-wait-online.enable = false;

  boot.kernel.sysctl."net.ipv4.tcp_fastopen" = 0; # else DoT won't work

  services = {
    resolved = {
      enable = true;
      settings.Resolve = {
        DNS = [
          "9.9.9.9#dns.quad9.net"
          "149.112.112.112#dns.quad9.net"
        ];
        MulticastDNS = "resolve";
        DNSOverTLS = "yes"; # no fallback to plain
        Domains = [ "~." ];
        FallbackDNS = "";
      };
    };
  };

  netsec.zapret = {
    enable = true;
    addHosts = true;
    strategy = "s4_any";
  };

  # remember to set auto-redirect in settings
  # if you want internet
  programs.clash-verge = {
    enable = true;
    tunMode = true;
    serviceMode = true;
    group = "wheel";
  };
}
