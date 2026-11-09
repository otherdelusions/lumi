{ pkgs, ... }:
{
  imports = [
    ./users.nix
    ./home.nix
    ./hardware.nix
    ./firmware.nix
    ./disko.nix
    ./desktop
    ./laptop.nix
    ./networking.nix
  ];

  documentation.man.cache.enable = false;
  time.timeZone = "Europe/Moscow";

  environment.systemPackages = with pkgs; [
    loupe
    papers
    unzip
    zip
    (mpv.override { scripts = with mpvScripts; [ thumbfast ]; })
    bubblewrap
    mcp-nixos
  ];
}
