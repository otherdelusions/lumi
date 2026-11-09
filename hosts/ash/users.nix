# nixos users setup on host
{ homelab, ... }:
{
  imports = [ ../../users/ferret ];

  users.users.ferret.extraGroups = [ homelab.group ];

  users.users.ferret.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGyfwM5xpexbGKqVwGGOUvsIUjafEAmkFR3mgyMNRoLe ferret@ember"
  ];
}
