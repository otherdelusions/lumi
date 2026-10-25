{
  imports = [
    # Enable services by importing their configuration here.
    # ./copyparty.nix
    # ./monbooru.nix
    # ./navidrome.nix
    # ./suwayomi.nix
    # ./forgejo.nix
    # ./samba.nix
  ];

  services.avahi = {
    enable = true;
    openFirewall = true;
    nssmdns4 = true;
    publish = {
      enable = true;
      userServices = true;
      workstation = true;
      domain = true;
    };
  };
}
