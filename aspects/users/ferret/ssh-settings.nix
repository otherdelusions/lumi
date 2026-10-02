{
  den.aspects.ferret = {
    homeManager =
      { osConfig, ... }:
      {
        programs.ssh.settings = {
          "github.com" = {
            User = "git";
            IdentityFile = osConfig.security.nix-secrets.secrets."ssh_keys/to_github".path;
            IdentitiesOnly = true;
          };
          ash = {
            IdentityFile = osConfig.security.nix-secrets.secrets."ssh_keys/to_ash".path;
            IdentitiesOnly = true;
          };
        };
      };
  };
}
