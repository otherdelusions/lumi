# hm users setup on host
{ config, ... }:
{
  home-manager.users.ferret = {
    imports = [
      ../../users/ferret/home/common
      ../../users/ferret/home/desktop # since its a laptop we also need gui
      ../../users/ferret/home/theme
    ];

    # specific user hm settings on a specific host
    programs.ssh.settings.ash = {
      IdentityFile = config.security.nix-secrets.secrets."ssh_keys/to_ash".path;
      IdentitiesOnly = true;
    };
  };
}
