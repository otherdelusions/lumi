{ den, ... }:
{
  den.aspects.ash = {
    includes = with den.aspects; [
      server
      dev
      homelab
    ];

    nixos = {
      documentation.man.cache.enable = false;

      security.nix-secrets = {
        secrets = {
          "services/copyparty/ferret_pass" = {
            recipients = [ "ash" ];
            owner = "homelab";
          };
        };
      };
    };
  };
}
