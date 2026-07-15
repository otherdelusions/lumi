{
  den.aspects.delusion = {
    nixos = {
      sops.secrets.github_ssh_key = {
        sopsFile = ../../../secrets/users/delusion.yaml;
        owner = "delusion";
      };
    };

    homeManager =
      { osConfig, ... }:
      {
        programs.ssh.settings = {
          "github.com" = {
            User = "git";
            IdentityFile = osConfig.sops.secrets.github_ssh_key.path;
            IdentitiesOnly = true;
          };
        };
      };
  };
}
