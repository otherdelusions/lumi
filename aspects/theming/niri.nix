{ den, ... }:
{
  den.aspects.theming.includes = [ den.aspects.theming.niri ];

  den.aspects.theming.niri = {
    includes = [ den.aspects.theming.options ];

    provides.to-users.homeManager = { config, ... }: {
      wayland.windowManager.niri.settings = with config.theme.colors.withHashtag; {
        overview.backdrop-color = base00;

        cursor = {
          xcursor-theme = config.theme.cursor.name;
          xcursor-size = config.theme.cursor.size;
        };

        layout = {
          background-color = base00;
          border = {
            on = { };
            active-color = base08;
            inactive-color = base00;
          };
          focus-ring.off = { };
        };
      };
    };
  };
}
