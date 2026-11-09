# nixos users setup on host
{ config, ... }:
{
  imports = [ ../../users/ferret ];

  services.displayManager.dux-greeter.configHome = config.users.users.ferret.home;

  # users' host specific secrets
  security.nix-secrets.secrets."ssh_keys/to_ash" = {
    recipients = [ "ferret" ];
    owner = "ferret";
  };
}
