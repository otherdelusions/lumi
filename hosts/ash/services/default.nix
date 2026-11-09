{
  imports = [
    ./base.nix
    ./forgejo.nix
    ./navidrome.nix
    ./opencloud.nix
    ./suwayomi.nix
  ];

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
}
