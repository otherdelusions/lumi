{ den, ... }:
{
  den.aspects.theming.stylix.includes = [ den.aspects.theming.stylix.niri ];

  den.aspects.theming.stylix.niri = {
    homeManager = { config, ... }: {
      wayland.windowManager.niri.settings =
        let
          inherit (config.lib.stylix) colors;
        in
        {
          layout.background-color = colors.withHashtag.base00;
          overview.backdrop-color = colors.withHashtag.base00;

          cursor = {
            xcursor-theme = config.stylix.cursor.name;
            xcursor-size = config.stylix.cursor.size;
          };

          layout.border = {
            on = { };
            active-color = colors.withHashtag.base0B;
            inactive-color = colors.withHashtag.base03;
          };

          layout.focus-ring.off = { };
        };
    };
  };
}
