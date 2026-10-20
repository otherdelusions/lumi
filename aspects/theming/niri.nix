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
          overview.backdrop-color = colors.withHashtag.base00;

          cursor = {
            xcursor-theme = config.theme.cursor.name;
            xcursor-size = config.theme.cursor.size;
          };

          layout = {
            background-color = colors.withHashtag.base00;
            border = {
              on = { };
              active-color = colors.withHashtag.base0B;
              inactive-color = colors.withHashtag.base03;
            };
            focus-ring.off = { };
          };
        };
    };
  };
}
