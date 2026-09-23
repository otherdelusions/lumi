{ den, ... }:
{
  den.aspects.ash = {
    includes = with den.aspects.homelab; [
      services.avahi
      services.copyparty
    ];

    nixos = { lib, config, ... }: {
      sops.secrets =
        lib.genAttrs
          [
            "services/copyparty/ferret_pass"
          ]
          (_: {
            owner = config.homelab.user;
          });

      homelab.dirs.content = "/mirror";

      homelab.dirs.extra = [
        "/mirror/music"
      ];

      homelab.services = {
        copyparty = {
          openFirewall = true;

          accounts = {
            ferret.passwordFile = config.sops.secrets."services/copyparty/ferret_pass".path;
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
