{ config, pkgs, ... }:
{
  imports = [
    ../../modules/ferret.nix
    ../../modules/zapret.nix
    ../../modules/librewolf.nix
    ./hardware.nix
    ./firmware.nix
    ./disko.nix
    ./desktop.nix
    ./laptop.nix
    ./dns.nix
    ./librewolf/preferences.nix
    ./librewolf/extensions.nix
    ./librewolf/search.nix
  ];

  networking = {
    hostName = "ember";
    networkmanager.enable = true;
    enableIPv6 = false;
    firewall.trustedInterfaces = [ "Meta" ];
  };
  systemd.services.NetworkManager-wait-online.enable = false;
  boot.kernel.sysctl."net.ipv4.tcp_fastopen" = 0; # else DoT won't work
  time.timeZone = "Europe/Moscow";
  documentation.man.cache.enable = false;

  services.avahi = {
    enable = true;
    nssmdns4 = true;
  };
  netsec.zapret = {
    enable = true;
    addHosts = true;
    strategy = "s2_any";
  };
  programs.clash-verge = {
    enable = true;
    tunMode = true;
    serviceMode = true;
    group = "wheel";
  };
  programs.librewolf.enable = true;

  environment.systemPackages = with pkgs; [
    loupe
    papers
    unzip
    zip
    (mpv.override { scripts = with mpvScripts; [ thumbfast ]; })
    bubblewrap
    mcp-nixos
  ];

  security.nix-secrets.secrets."ssh_keys/to_ash" = {
    recipients = [ "ferret" ];
    owner = "ferret";
  };
  home-manager.users.ferret = {
    imports = [ ../../home/ferret/desktop.nix ];
    programs.ssh.settings.ash = {
      IdentityFile = config.security.nix-secrets.secrets."ssh_keys/to_ash".path;
      IdentitiesOnly = true;
    };
  };
}
