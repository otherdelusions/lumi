{ inputs, den, ... }:
{
  flake.homelabServices.copyparty = {
    description = "file server";
    iconUrl = "https://cdn.jsdelivr.net/gh/homarr-labs/dashboard-icons/png/copyparty.png";
    path = "aspects/homelab/services/copyparty.nix";
  };

  den.aspects.homelab.services.copyparty = {
    includes = [ den.aspects.homelab.services ];

    nixos =
      { config, lib, ... }:
      let
        hl = config.homelab;
        cfg = hl.services.copyparty;
      in
      {
        options.homelab.services.copyparty = {
          settings = lib.mkOption {
            type = lib.types.attrsOf lib.types.anything;
            default = { };
            description = "Copyparty settings";
          };

          accounts = lib.mkOption {
            type = lib.types.attrsOf lib.types.anything;
            default = { };
            description = "Copyparty user accounts";
          };

          volumes = lib.mkOption {
            type = lib.types.attrsOf lib.types.anything;
            default = { };
            description = "Copyparty volume mapping and settings";
          };

          port = lib.mkOption {
            type = lib.types.port;
            default = 3210;
            description = "Copyparty port";
          };

          openFirewall = lib.mkOption {
            type = lib.types.bool;
            default = false;
            description = "Whether to open the port in the firewall";
          };
        };

        imports = [ inputs.copyparty.nixosModules.default ];

        config = {
          services.copyparty = {
            enable = true;

            user = config.homelab.user;
            group = config.homelab.group;

            settings = lib.mkMerge [
              (lib.mkDefault {
                e2dsa = true;
                e2tsr = true;
                e2vu = true;
                z = true;
                i = "0.0.0.0";
                no-reload = true;
              })
              cfg.settings
              { p = cfg.port; }
            ];

            inherit (cfg) accounts volumes;
          };

          networking.firewall.allowedTCPPorts = lib.mkIf cfg.openFirewall [ cfg.port ];
        };
      };
  };
}
