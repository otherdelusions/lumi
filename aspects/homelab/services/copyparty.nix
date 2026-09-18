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
        inherit (lib)
          mkOption
          literalExpression
          mkMerge
          mkDefault
          mkIf
          ;

        inherit (lib.types)
          externalPath
          attrsOf
          anything
          port
          bool
          ;

        hl = config.homelab;
        cfg = hl.services.copyparty;
      in
      {
        options.homelab.services.copyparty = {
          dataDir = mkOption {
            type = externalPath;
            default = "${hl.dirs.data}/services/copyparty";
            example = "/var/lib/copyparty";
            description = "Copyparty data directory.";
          };

          settings = mkOption {
            type = attrsOf anything;
            default = { };
            example = literalExpression ''
              {
                e2dsa = false;
                chpw = true;
                i = "127.0.0.1";
              }
            '';
            description = "Additional copyparty settings.";
          };

          accounts = mkOption {
            type = attrsOf anything;
            default = { };
            example = literalExpression ''
              {
                ed.passwordFile = "/run/secrets/party-pass";
              }
            '';
            description = "Copyparty user accounts settings.";
          };

          volumes = mkOption {
            type = attrsOf anything;
            default = { };
            example = literalExpression ''
              {
                "/" = {
                  path = "/srv/copyparty";
                  access = {
                    A = "ed";
                    r = "*";
                  };
                };
              }
            '';
            description = "Copyparty volume mapping and settings.";
          };

          port = mkOption {
            type = port;
            default = 3210;
            example = "8080";
            description = "Copyparty service port.";
          };

          openFirewall = mkOption {
            type = bool;
            default = false;
            example = true;
            description = "Whether to open the specified port in the firewall.";
          };
        };

        imports = [ inputs.copyparty.nixosModules.default ];

        config = {
          services.copyparty = {
            enable = true;

            inherit (hl) user group;
            inherit (cfg) accounts volumes;

            settings = mkMerge [
              (mkDefault {
                e2dsa = true;
                e2tsr = true;
                e2vu = true;
                z = true;
                i = "0.0.0.0";
                no-reload = true;
                localtime = true;
                rotf-tz = hl.timeZone;
                hist = cfg.dataDir;
              })
              cfg.settings
              { p = cfg.port; }
            ];
          };

          networking.firewall.allowedTCPPorts = mkIf cfg.openFirewall [ cfg.port ];
        };
      };
  };
}
