{
  den.aspects.homelab = {
    nixos =
      { lib, config, ... }:
      let
        inherit (lib)
          mkOption
          literalExpression
          genAttrs
          unique
          ;

        inherit (lib.types)
          externalPath
          listOf
          str
          ;

        hl = config.homelab;
      in
      {
        options.homelab.dirs = {
          data = mkOption {
            type = externalPath;
            default = "/var/lib/homelab";
            example = "/run/homelab";
            description = "Homelab data directory, holds runtime state of services.";
          };

          content = mkOption {
            type = externalPath;
            default = hl.dirs.data;
            example = "/srv";
            description = "Homelab content directory, holds bulk media served by services.";
          };

          extra = mkOption {
            type = listOf str;
            default = [ ];
            example = literalExpression ''
              [
                "/srv/media/music"
                "/srv/stuff"
                "/homelab/data"
              ]
            '';
            description = "List of extra homelab directories to create.";
          };
        };

        config = {
          systemd.tmpfiles.settings.homelab-base = {
            "${hl.dirs.data}".d = {
              mode = "0755";
              inherit (hl) user;
              inherit (hl) group;
            };
          };

          systemd.tmpfiles.settings.homelab-extra = genAttrs (unique hl.dirs.extra) (_: {
            d = {
              mode = "2775";
              inherit (hl) user;
              inherit (hl) group;
            };
          });
        };
      };
  };
}
