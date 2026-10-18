{ den, ... }:
{
  den.aspects.theming.includes = [ den.aspects.theming.niri ];

  den.aspects.theming.niri = {
    provides.to-users.homeManager = { config, ... }: {
      wayland.windowManager.niri.settings =
        let
          inherit (config.theme) colors;
        in
        {
          layout.background-color = colors.withHashtag.base00;
          overview.backdrop-color = colors.withHashtag.base00;

          cursor = {
            xcursor-theme = config.theme.cursor.name;
            xcursor-size = config.theme.cursor.size;
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
