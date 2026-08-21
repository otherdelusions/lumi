{
  den.aspects.delusion = {
    nixos = {
      sops.secrets."ssh_keys/to_github" = {
        sopsFile = ../../../secrets/users/delusion.yaml;
        owner = "delusion";
      };

      sops.secrets."ssh_keys/to_ash".owner = "delusion";
    };

    homeManager =
      { osConfig, ... }:
      {
        programs.ssh.settings = {
          "github.com" = {
            User = "git";
            IdentityFile = osConfig.sops.secrets."ssh_keys/to_github".path;
            IdentitiesOnly = true;
          };
          ash = {
            IdentityFile = osConfig.sops.secrets."ssh_keys/to_ash".path;
            IdentitiesOnly = true;
          };
        };
      };
  };
}
