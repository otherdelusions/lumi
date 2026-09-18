{ den, ... }:
{
  flake.homelabServices.samba = {
    description = "SMB file sharing protocol";
    iconUrl = "https://cdn.jsdelivr.net/gh/homarr-labs/dashboard-icons/png/samba-server.png";
    path = "aspects/homelab/services/samba.nix";
  };

  den.aspects.homelab.services.samba = {
    includes = [ den.aspects.homelab.services ];

    nixos =
      { config, lib, ... }:
      let
        inherit (lib)
          mkOption
          literalExpression
          mkMerge
          mkDefault
          mapAttrs
          ;

        inherit (lib.types)
          attrsOf
          anything
          ;

        hl = config.homelab;
        cfg = hl.services.samba;
      in
      {
        options.homelab.services.samba = {
          global = mkOption {
            type = attrsOf anything;
            default = { };
            example = literalExpression ''
              {
                workgroup = "WORKGROUP";
                "server string" = "Home server";
                "max protocol" = "SMB3";
              }
            '';
            description = "Global Samba settings.";
          };

          common = mkOption {
            type = attrsOf anything;
            default = { };
            example = literalExpression ''
              {
                browseable = "yes";
                "read only" = "no";
                "guest ok" = "no";
                "create mask" = "0644";
              }
            '';
            description = "Settings applied to all shares.";
          };

          shares = mkOption {
            type = attrsOf (attrsOf anything);
            default = { };
            example = literalExpression ''
              {
                public = {
                  path = "/srv/public";
                  "read only" = "yes";
                  "guest ok" = "yes";
                };

                media = {
                  path = "/srv/media";
                  "read only" = "no";
                  "guest ok" = "no";
                };
              }
            '';
            description = "Individual share settings. Values set here override common settings.";
          };
        };

        config = {
          # wsd discovery
          networking.firewall = {
            allowedTCPPorts = [ 5357 ];
            allowedUDPPorts = [ 3702 ];
          };

          services.samba = {
            enable = true;
            openFirewall = true;

            settings = {
              global = mkMerge [
                (mkDefault {
                  workgroup = "WORKGROUP";
                  "server string" = config.networking.hostName;
                  "netbios name" = config.networking.hostName;
                  "security" = "user";
                  "invalid users" = [ "root" ];
                  "guest account" = "nobody";
                  "map to guest" = "bad user";
                  "passdb backend" = "tdbsam";
                })
                cfg.global
              ];
            }
            // mapAttrs (
              _: value:
              {
                browseable = "yes";
                "read only" = "no";
                writeable = "yes";
                "guest ok" = "no";
                "create mask" = "0644";
                "directory mask" = "0755";
              }
              // cfg.common
              // value
            ) cfg.shares;
          };

          services.samba-wsdd = {
            enable = true;
            discovery = true;
          };
        };
      };
  };
}
