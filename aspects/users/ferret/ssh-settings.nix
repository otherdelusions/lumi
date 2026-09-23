{
  den.aspects.ferret = {
    nixos = { lib, ... }: {
      # ssh user keys
      sops.secrets =
        lib.genAttrs
          [
            "ssh_keys/to_github"
            "ssh_keys/to_ash"
          ]
          (_: {
            sopsFile = ../../../secrets/users/ferret.yaml;
            owner = "ferret";
          });
    };

    homeManager =
      { osConfig, ... }:
      {
        # ssh user auth config
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
