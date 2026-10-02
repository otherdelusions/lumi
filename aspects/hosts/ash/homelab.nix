{ den, ... }:
{
  den.aspects.ash = {
    includes = with den.aspects.homelab; [
      services.avahi
      services.copyparty
    ];

    nixos = { config, ... }: {
      homelab.dirs.content = "/mirror";

      homelab.dirs.extra = [
        "/mirror/music"
      ];

      homelab.services = {
        copyparty = {
          openFirewall = true;

          accounts = {
            ferret.passwordFile = config.security.nix-secrets.secrets."services/copyparty/ferret_pass".path;
          };

          volumes = {
            "/" = {
              path = "/mirror";
              access.rwmda = [ "ferret" ];
            };
          };
        };
      };
    };
  };
}
