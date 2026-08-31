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
        hl = config.homelab;
        cfg = hl.services.monbooru;
        settingsFormat = pkgs.formats.toml { };

        galleryOpts = _: {
          options = {
            name = lib.mkOption {
              type = lib.types.strMatching "[A-Za-z0-9_-]+";
              description = "Gallery name";
            };
            gallery_path = lib.mkOption {
              type = lib.types.externalPath;
              description = "Filesystem gallery root";
            };
          };
        };
      in
      {
        imports = [ inputs.self.nixosModules.monbooru ];

        options.homelab.services.monbooru = {
          dataDir = lib.mkOption {
            type = lib.types.externalPath;
            default = "${hl.dirs.data}/services/monbooru";
            description = "Monbooru data directory";
          };

          bindAddress = lib.mkOption {
            type = lib.types.str;
            default = "127.0.0.1:8080";
            description = "address:port to listen on";
          };

          baseUrl = lib.mkOption {
            type = lib.types.str;
            default = "http://localhost:8080";
            description = "Monbooru base URL";
          };

          galleries = lib.mkOption {
            type = lib.types.listOf (lib.types.submodule galleryOpts);
            default = [ ];
            description = "List of named galleries to index";
          };

          passwordFile = lib.mkOption {
            type = lib.types.nullOr lib.types.path;
            default = null;
            description = "Path to a file containing a password to derive hash from";
          };

          settings = lib.mkOption {
            inherit (settingsFormat) type;
            default = { };
            description = "Monbooru settings";
          };
        };

        config = {
          homelab.dirs.extra = map (g: g.path) cfg.galleries;

          services.monbooru = {
            enable = true;
            openFirewall = true;

            inherit (hl) user group timeZone;
            inherit (cfg) passwordFile;

            settings = lib.mkMerge [
              (lib.mkDefault {
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
