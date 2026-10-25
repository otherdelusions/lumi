{ inputs, lib, ... }:
{
  imports = [ inputs.nix-secrets.nixosModules.default ];
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
    security.nix-secrets = {
      enable = true;
      storage = ../secrets;
    };
    nix = {
      settings = {
        experimental-features = [
          "nix-command"
          "flakes"
          "pipe-operators"
        ];
        accept-flake-config = true;
        auto-optimise-store = true;
        warn-dirty = false;
        connect-timeout = lib.mkDefault 5;
        fallback = true;
        builders-use-substitutes = true;
        trusted-users = [ "@wheel" ];
      };
      gc = {
        automatic = true;
        dates = "weekly";
        options = "--delete-older-than 7d";
      };
      channel.enable = lib.mkDefault false;
      nixPath = [ "nixpkgs=${inputs.nixpkgs}" ];
    };
  };
}
