{
  imports = [
    ./_registry.nix
    ./_docs.nix
  ];

  den.aspects.homelab = { user }: {
    nixos =
      { lib, config, ... }:
      let
        hl = config.homelab;
      in
      {
        options.homelab = {
          user = lib.mkOption {
            default = "homelab";
            type = lib.types.str;
            description = "Homelab user name";
          };

          group = lib.mkOption {
            default = "homelab";
            type = lib.types.str;
            description = "Homelab group name";
          };

          timeZone = lib.mkOption {
            default = config.time.timeZone;
            type = lib.types.nullOr lib.types.str;
            description = "Homelab timezone";
          };

          baseDomain = lib.mkOption {
            default = "localhost";
            type = lib.types.str;
            description = "Base domain of the homelab";
          };
        };

        config = {
          systemd.tmpfiles.rules = [
            "d ${hl.dirs.data} 0755 ${hl.user} ${hl.group} -"
          ];

          users = {
            groups.${hl.group}.gid = 1500;
            users.${hl.user} = {
              isSystemUser = true;
              uid = 1500;
              inherit (hl) group;
            };
          };

          users.users.${user.userName}.extraGroups = [ hl.group ];
        };
      };
  };
}
