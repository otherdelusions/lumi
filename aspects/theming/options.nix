{
  den.aspects.theming.options = {
    provides.to-users.homeManager =
      {
        config,
        lib,
        pkgs,
        ...
      }:
      let
        colorDefaults = {
          base00 = "111111";
          base01 = "2e2e2e";
          base02 = "3f3f3f";
          base03 = "7f7f7f";
          base04 = "dbdedf";
          base05 = "ffffff";
          base06 = "0070f0";
          base07 = "00b7f1";
          base08 = "1aebf1";
          base09 = "f4424c";
          base0A = "ff3964";
          base0B = "fb8f05";
          base0C = "f6bc16";
          base0D = "f7e396";
          base0E = "c2fc32";
          base0F = "00ff77";
        };

        colorOptions =
          defaults:
          mapAttrs (
            _: default:
            mkOption {
              type = strMatching "[0-9a-fA-F]{6}";
              inherit default;
            }
          ) defaults;

        colorFormats = colors: names: {
          withHashtag = mkOption {
            type = attrsOf str;
            readOnly = true;
            default = genAttrs names (name: "#${colors.${name}}");
          };

          withRgb = mkOption {
            type = attrsOf (attrsOf int);
            readOnly = true;
            default = genAttrs names (
              name:
              let
                channel = start: lib.fromHexString (builtins.substring start 2 colors.${name});
              in
              {
                r = channel 0;
                g = channel 2;
                b = channel 4;
              }
            );
          };
        };

        supportedBrowsers = [
          "librewolf"
        ];

        inherit (lib) mkOption mapAttrs genAttrs;
        inherit (lib.types)
          int
          str
          strMatching
          package
          submodule
          path
          nullOr
          coercedTo
          pathInStore
          attrsOf
          listOf
          ;

        fontType = submodule {
          options = {
            package = mkOption {
              type = package;
            };

            name = mkOption {
              type = str;
            };
          };
        };
      in
      {
        options.theme = {
          name = mkOption {
            type = str;
            default = "lumi";
          };

          colors =
            colorOptions colorDefaults // colorFormats config.theme.colors (builtins.attrNames colorDefaults);

          fonts = {
            monospace = mkOption {
              type = fontType;
              default = {
                package = pkgs.dejavu_fonts;
                name = "DejaVu Sans Mono";
              };
            };

            sansSerif = mkOption {
              type = fontType;
              default = {
                package = pkgs.dejavu_fonts;
                name = "DejaVu Sans";
              };
            };

            serif = mkOption {
              type = fontType;
              default = {
                package = pkgs.dejavu_fonts;
                name = "DejaVu Serif";
              };
            };
          };

          wallPaper = mkOption {
            type = nullOr (coercedTo path (src: "${src}") pathInStore);
            default = "${../../config/wallpaper}/gray-buildings.jpg";
          };

          cursor = mkOption {
            type = submodule {
              options = {
                name = mkOption {
                  type = str;
                  default = "Adwaita";
                };

                package = mkOption {
                  type = package;
                  default = pkgs.adwaita-icon-theme;
                };

                size = mkOption {
                  type = int;
                  default = 24;
                };
              };
            };
          };

          browser = genAttrs supportedBrowsers (_: {
            profileNames = mkOption {
              type = listOf str;
              default = [ ];
            };
          });
        };
      };
  };
}
