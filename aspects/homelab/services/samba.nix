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
        hl = config.homelab;
        cfg = hl.services.samba;
      in
      {
        options.homelab.services.samba = {
          global = lib.mkOption {
            type = lib.types.attrsOf lib.types.anything;
            default = { };
            description = "Global Samba settings";
          };

          common = lib.mkOption {
            type = lib.types.attrsOf lib.types.anything;
            default = { };
            description = "Settings applied to all shares";
          };

          shares = lib.mkOption {
            type = lib.types.attrsOf (lib.types.attrsOf lib.types.anything);
            default = { };
            description = "Individual share settings";
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
              global = lib.mkMerge [
                (lib.mapAttrs (_: lib.mkDefault) {
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
            // lib.mapAttrs (
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
