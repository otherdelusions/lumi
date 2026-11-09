{ theme, ... }: {
  imports = [ ./palette.nix ];

  wayland.windowManager.niri.settings = with theme.colors.withHashtag; {
    overview.backdrop-color = base00;

    cursor = {
      xcursor-theme = theme.cursor.name;
      xcursor-size = theme.cursor.size;
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
}
