{ config, pkgs, ... }:
{
  imports = [
    ../../users/ferret.nix
    ./hardware.nix
    ./firmware.nix
    ./disko.nix
    ./desktop.nix
    ./laptop.nix
    ./networking.nix
    ./librewolf
  ];

  networking.hostName = "ember";
  time.timeZone = "Europe/Moscow";
  documentation.man.cache.enable = false;

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
    imports = [ ../../home/ferret/desktop ];
    programs.ssh.settings.ash = {
      IdentityFile = config.security.nix-secrets.secrets."ssh_keys/to_ash".path;
      IdentitiesOnly = true;
    };
  };
}
