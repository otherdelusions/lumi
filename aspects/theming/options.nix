{
  den.aspects.theming = {
    homeManager =
      {
        config,
        lib,
        pkgs,
        ...
      }:
      let
        colorDefaults = {
          base00 = "151616";
          base01 = "192121";
          base02 = "343636";
          base03 = "424c4c";
          base04 = "d7dede";
          base05 = "efefef";
          base06 = "fefeff";
          base07 = "fefeff";
          base08 = "ea6637";
          base09 = "f7961a";
          base0A = "fbb627";
          base0B = "1ccbaf";
          base0C = "18cdc4";
          base0D = "11c9de";
          base0E = "f184d6";
          base0F = "61ccb6";
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
            mapAttrs (
              _: default:
              mkOption {
                type = strMatching "[0-9a-fA-F]{6}";
                inherit default;
              }
            ) colorDefaults
            // {
              withHashtag = mkOption {
                type = attrsOf str;
                readOnly = true;
                default = genAttrs (builtins.attrNames colorDefaults) (name: "#${config.theme.colors.${name}}");
              };

              withRgb = mkOption {
                type = attrsOf (attrsOf int);
                readOnly = true;
                default = genAttrs (builtins.attrNames colorDefaults) (
                  name:
                  let
                    channel = start: lib.fromHexString (builtins.substring start 2 config.theme.colors.${name});
                  in
                  {
                    r = channel 0;
                    g = channel 2;
                    b = channel 4;
                  }
                );
              };
            };

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
