{ den, ... }:
{
  den.aspects.ash = {
    includes = with den.aspects; [
      server
      homelab
      theming.helix
    ];

    nixos = {
      documentation.man.cache.enable = false;

      security.nix-secrets = {
        identityPaths = [
          "/etc/ssh/ssh_host_ed25519_key"
        ];
        recipientAliases = {
          ash = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGpEpH0wV2JehS/7fDYFKWZfkFeLcQ/opZAtLoVxfQrH root@ash";
        };
      };
    };
  };
}
