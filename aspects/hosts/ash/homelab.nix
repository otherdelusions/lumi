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
            "services/copyparty/delusion_pass"
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
            delusion.passwordFile = config.sops.secrets."services/copyparty/delusion_pass".path;
          };

          volumes = {
            "/" = {
              path = "/mirror";
              access.rwmda = [ "delusion" ];
            };
          };
        };
      };
    };
  };
}
