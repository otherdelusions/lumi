{
  den.aspects.homelab = {
    nixos =
      { lib, config, ... }:
      let
        hl = config.homelab;
      in
      {
        options.homelab.dirs = {
          data = lib.mkOption {
            type = lib.types.externalPath;
            default = "/var/lib/homelab";
            description = "Homelab data directory, holds runtime state of services";
          };

          content = lib.mkOption {
            type = lib.types.externalPath;
            default = hl.dirs.data;
            description = "Homelab content directory, holds bulk media served by services";
          };

          extra = lib.mkOption {
            type = lib.types.listOf lib.types.str;
            default = [ ];
            description = "List of extra homelab directories";
          };
        };

        config = lib.mkIf (hl.dirs.extra != [ ]) {
          systemd.tmpfiles.rules = map (d: "d ${d} 2775 ${hl.user} ${hl.group} -") (lib.unique hl.dirs.extra);
        };
      };
  };
}
