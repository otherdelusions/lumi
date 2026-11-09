{ lib, ... }:
{
  imports = [
    ./home-manager.nix
    ./nix.nix
    ./secrets.nix
  ];

  system.stateVersion = lib.mkDefault "26.05";

  time.timeZone = lib.mkDefault "UTC";
  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = lib.genAttrs [
      "LC_NUMERIC"
      "LC_MONETARY"
      "LC_PAPER"
      "LC_MEASUREMENT"
      "LC_TELEPHONE"
    ] (_: lib.mkDefault "ru_RU.UTF-8");
  };

  networking.firewall = {
    enable = lib.mkDefault true;
    logRefusedConnections = lib.mkDefault false;
    allowPing = true;
  };
}
