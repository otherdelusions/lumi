{
  den.aspects.ferret.provides = {
    to-hosts = {
      nixos.security.nix-secrets.secrets."ssh_keys/to_github" = {
        recipients = [ "ferret" ];
        owner = "ferret";
      };

      homeManager =
        { osConfig, ... }:
        {
          programs.ssh.settings."github.com" = {
            User = "git";
            IdentityFile = osConfig.security.nix-secrets.secrets."ssh_keys/to_github".path;
            IdentitiesOnly = true;
          };
        };
    };

    ember = {
      nixos.security.nix-secrets.secrets."ssh_keys/to_ash" = {
        recipients = [ "ferret" ];
        owner = "ferret";
      };

      homeManager =
        { osConfig, ... }:
        {
          programs.ssh.settings.ash = {
            IdentityFile = osConfig.security.nix-secrets.secrets."ssh_keys/to_ash".path;
            IdentitiesOnly = true;
          };
        };
    };

    ash.user.openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGyfwM5xpexbGKqVwGGOUvsIUjafEAmkFR3mgyMNRoLe ferret@ember"
    ];
  };
}
