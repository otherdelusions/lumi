{ den, ... }:
{
  den.aspects.tiling-wm.niri.includes = [ den.aspects.tiling-wm.niri.base ];

  den.aspects.tiling-wm.niri.base = {
    homeManager =
      { lib, config, ... }:
      {
        options.programs.niri = {
          mainOutput = lib.mkOption {
            type = lib.types.str;
            default = "eDP-1";
            description = "Main output name (use 'niri msg outputs')";
          };
        };

        config.programs.niri.settings = {
          prefer-no-csd = true;
          hotkey-overlay.skip-at-startup = true;
          layout.border.enable = true;
          input.focus-follows-mouse.enable = true;

          outputs.${config.programs.niri.mainOutput} = {
            scale = 1;
            position = {
              x = 0;
              y = 0;
            };
          };

          layout = {
            tab-indicator = {
              position = "top";
              width = 8;
              gap = 8;
              length.total-proportion = 1.0;
              place-within-column = true;
            };

            default-column-width = {
              proportion = 0.5;
            };

            preset-column-widths = [
              { proportion = 2. / 3.; }
              { proportion = 1.0; }
              { proportion = 1. / 3.; }
              { proportion = 0.5; }
            ];
          };

          cursor = {
            theme = lib.mkDefault "Adwaita";
            size = lib.mkDefault 24;
          };
        };
      };
  };
}
