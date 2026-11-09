{ lib, osConfig, ... }:
{
  programs.ssh = {
    enable = lib.mkDefault true;
    enableDefaultConfig = false;

    settings = {
      "*".AddKeysToAgent = "yes";

      ash = {
        HostName = "ash.local";
        User = "ferret";
      };

      ember = {
        HostName = "ember.local";
        User = "ferret";
      };

      "github.com" = {
        User = "git";
        IdentityFile = osConfig.security.nix-secrets.secrets."ssh_keys/to_github".path;
        IdentitiesOnly = true;
      };
    };
  };
}
