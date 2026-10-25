{ lib, ... }:
{
  imports = [
    ./nix.nix
    ./secrets.nix
  ];

  options.desktop.terminal = lib.mkOption {
    type = lib.types.nullOr lib.types.str;
    default = null;
    description = "Terminal shared by desktop launchers and shortcuts.";
  };

  config = {
    system.stateVersion = "26.05";
    time.timeZone = lib.mkDefault "UTC";
    i18n = {
      defaultLocale = "en_US.UTF-8";
      extraLocaleSettings = lib.genAttrs [
        "LC_NUMERIC"
        "LC_MONETARY"
        "LC_PAPER"
        "LC_MEASUREMENT"
        "LC_TELEPHONE"
      ] (_: "ru_RU.UTF-8");
    };

    networking.firewall = {
      enable = lib.mkDefault true;
      logRefusedConnections = lib.mkDefault false;
      allowPing = true;
    };
  };
}
