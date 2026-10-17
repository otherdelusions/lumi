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
          homelab.services.samba = {
            global = {
              workgroup = mkDefault "WORKGROUP";
              "server string" = mkDefault config.networking.hostName;
              "netbios name" = mkDefault config.networking.hostName;
              security = mkDefault "user";
              "invalid users" = mkDefault [ "root" ];
              "guest account" = mkDefault "nobody";
              "map to guest" = mkDefault "bad user";
              "passdb backend" = mkDefault "tdbsam";
            };

            common = {
              browseable = mkDefault "yes";
              "read only" = mkDefault "no";
              "guest ok" = mkDefault "no";
              "create mask" = mkDefault "0644";
              "directory mask" = mkDefault "0755";
            };
          };

          # wsd discovery
          networking.firewall = {
            allowedTCPPorts = [ 5357 ];
            allowedUDPPorts = [ 3702 ];
          };

          services.samba = {
            enable = true;
            openFirewall = true;

            settings = {
              inherit (cfg) global;
            }
            // mapAttrs (_: value: cfg.common // value) cfg.shares;
          };

          services.samba-wsdd = {
            enable = true;
            discovery = true;
          };
        };
      };
  };
}
