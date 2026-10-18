{
  imports = [
    ./_registry.nix
    ./_docs.nix
  ];

  den.aspects.homelab = {
    nixos =
      {
        host,
        lib,
        config,
        ...
      }:
      let
        inherit (lib)
          mkOption
          mkIf
          ;

        inherit (lib.types)
          str
          nullOr
          ;

        hl = config.homelab;
        isHostUser = lib.any (user: user.userName == hl.user) (builtins.attrValues host.users);
      in
      {
        options.homelab = {
          user = mkOption {
            type = str;
            default = "homelab";
            example = "media";
            description = "User under which homelab runs.";
          };

          group = mkOption {
            type = str;
            default = "homelab";
            example = "media";
            description = "Group under which homelab runs.";
          };

          timeZone = mkOption {
            type = nullOr str;
            default = config.time.timeZone;
            example = "America/New_York";
            description = "Homelab's timezone.";
          };

          baseDomain = mkOption {
            type = str;
            default = "localhost";
            example = "example.com";
            description = "Base domain of the homelab.";
          };
        };

        config = {
          users = {
            groups.${hl.group}.gid = 1500;

            users.${hl.user} = mkIf (!isHostUser) {
              isSystemUser = true;
              uid = 1500;
              inherit (hl) group;
            };
          };
        };
      };

    provides.to-users.user = { osConfig, ... }: {
      extraGroups = [ osConfig.homelab.group ];
    };
  };
}
