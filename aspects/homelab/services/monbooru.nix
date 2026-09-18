{ den, inputs, ... }:
{
  flake.homelabServices.monbooru = {
    description = "booru-style gallery";
    iconUrl = "https://avatars.githubusercontent.com/u/307393017?s=200&v=4";
    path = "aspects/homelab/services/monbooru.nix";
  };

  den.aspects.homelab.services.monbooru = {
    includes = [ den.aspects.homelab.services ];

    nixos =
      {
        lib,
        pkgs,
        config,
        ...
      }:
      let
        inherit (lib)
          mkOption
          literalExpression
          mkMerge
          mkDefault
          ;

        inherit (lib.types)
          strMatching
          externalPath
          str
          listOf
          submodule
          nullOr
          path
          ;

        hl = config.homelab;
        cfg = hl.services.monbooru;
        settingsFormat = pkgs.formats.toml { };

        galleryOpts = _: {
          options = {
            name = mkOption {
              type = strMatching "[A-Za-z0-9_-]+";
              description = "Gallery name.";
            };
            gallery_path = mkOption {
              type = externalPath;
              description = "Filesystem gallery root.";
            };
          };
        };
      in
      {
        imports = [ inputs.self.nixosModules.monbooru ];

        options.homelab.services.monbooru = {
          dataDir = mkOption {
            type = externalPath;
            default = "${hl.dirs.data}/services/monbooru";
            example = "/var/lib/monbooru";
            description = "Monbooru data directory.";
          };

          bindAddress = mkOption {
            type = str;
            default = "127.0.0.1:8080";
            example = "0.0.0.0:9090";
            description = "address:port to listen on.";
          };

          baseUrl = mkOption {
            type = str;
            default = "http://localhost:8080";
            example = "https://monbooru.example.com";
            description = "Monbooru base URL.";
          };

          galleries = mkOption {
            type = listOf (submodule galleryOpts);
            default = [ ];
            example = literalExpression ''
              [
                { name = "default"; gallery_path = "/srv/monbooru/gallery"; }
                { name = "art"; gallery_path = "/srv/monbooru/art"; }
              ]
            '';
            description = "List of named galleries to index.";
          };

          passwordFile = mkOption {
            type = nullOr path;
            default = null;
            example = "/run/secrets/monbooru-password";
            description = "Path to a file containing a plaintext web UI password.";
          };

          settings = mkOption {
            inherit (settingsFormat) type;
            default = { };
            example = literalExpression ''
              {
                server.monloader_url = "http://localhost:9000";
                auth.session_lifetime_days = 30;
                log.level = "info";
              }
            '';
            description = "Monbooru service settings";
          };
        };

        config = {
          homelab.dirs.extra = map (g: g.path) cfg.galleries;

          services.monbooru = {
            enable = true;
            openFirewall = true;

            inherit (hl) user group timeZone;
            inherit (cfg) passwordFile;

            settings = mkMerge [
              (mkDefault {
                server = {
                  bind_address = cfg.bindAddress;
                  base_url = cfg.baseUrl;
                };
              })
              cfg.settings
            ];
          };
        };
      };
  };
}
