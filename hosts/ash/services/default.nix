{
  imports = [
    ./base.nix
    ./opencloud.nix
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
