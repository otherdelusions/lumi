{
  wayland.windowManager.niri.settings = {
    prefer-no-csd = { };
    hotkey-overlay.skip-at-startup = { };
    gestures.hot-corners.off = { };

    output = {
      _args = [ "eDP-1" ];
      scale = 1;
      position._props = {
        x = 0;
        y = 0;
      };
    };

    input = {
      focus-follows-mouse = { };
      touchpad = {
        tap = { };
        dwt = { };
        natural-scroll = { };
        drag-lock = { };
        disabled-on-external-mouse = { };
      };

      mouse = {
        natural-scroll = { };
      };

      keyboard.xkb = {
        layout = "us,ru";
        options = "grp:win_space_toggle";
      };
    };

    layout = {
      tab-indicator = {
        position = "top";
        width = 8;
        gap = 8;
        length._props.total-proportion = 1.0;
        place-within-column = { };
      };

      default-column-width = {
        proportion = 0.5;
      };

      preset-column-widths._children = [
        { proportion = 2. / 3.; }
        { proportion = 1.0; }
        { proportion = 1. / 3.; }
        { proportion = 0.5; }
      ];
    };
  };
}
