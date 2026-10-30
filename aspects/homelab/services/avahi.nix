{ den, ... }:
{
  flake.homelabServices.avahi = {
    description = "zeroconf and mDNS";
    iconUrl = "https://upload.wikimedia.org/wikipedia/commons/thumb/7/7b/Avahi-logo.svg/330px-Avahi-logo.svg.png";
    path = "aspects/homelab/services/avahi.nix";
  };

  den.aspects.homelab.services.avahi = {
    includes = [ den.aspects.homelab.services ];

    nixos = {
      services.avahi = {
        enable = true;
        openFirewall = true;
        nssmdns4 = true;

        settings.publish = {
          disable-publishing = false;
          disable-user-service-publishing = false;
          publish-addresses = true;
          publish-workstation = true;
          publish-domain = true;
        };
      };
    };
  };
}
