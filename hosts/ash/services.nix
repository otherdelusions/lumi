{
  imports = [
    # Enable services by importing their configuration here.
    # ./services/copyparty.nix
    # ./services/monbooru.nix
    # ./services/navidrome.nix
    # ./services/suwayomi.nix
    # ./services/forgejo.nix
    # ./services/samba.nix
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
