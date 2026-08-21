{
  den.aspects.delusion = {
    nixos = { lib, ... }: {
      # ssh keys for delusion
      sops.secrets =
        lib.genAttrs
          [
            "ssh_keys/to_github"
            "ssh_keys/to_ash"
          ]
          (_: {
            sopsFile = ../../../secrets/users/delusion.yaml;
            owner = "delusion";
          });
    };

    homeManager =
      { osConfig, ... }:
      {
        # ssh auth config for delusion
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
