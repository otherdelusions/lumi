{ den, ... }:
{
  den.aspects.tiling-wm.niri.includes = [ den.aspects.tiling-wm.niri.binds ];

  den.aspects.tiling-wm.niri.binds = {
    homeManager =
      {
        host,
        config,
        lib,
        ...
      }:
      {
        options.wayland.windowManager.niri = {
          backlightDevice = lib.mkOption {
            type = lib.types.str;
            default = "backlight:intel_backlight";
            description = "Backlight device used in binds";
          };
        };

        config.wayland.windowManager.niri.settings.binds =
          let
            cfg = config.wayland.windowManager.niri;
            terminal = host.desktop.terminal;

            dmsIpc = [
              "dms"
              "ipc"
              "call"
            ];
          in
          {
            "Super+R" = {
              _props.repeat = false;
              spawn = dmsIpc ++ [
                "spotlight"
                "toggle"
              ];
            };
            "Super+P" = {
              _props.repeat = false;
              spawn = dmsIpc ++ [
                "powermenu"
                "toggle"
              ];
            };

            "XF86AudioRaiseVolume" = {
              _props.allow-when-locked = true;
              spawn = dmsIpc ++ [
                "audio"
                "increment"
                "5%"
              ];
            };

            "XF86AudioLowerVolume" = {
              _props.allow-when-locked = true;
              spawn = dmsIpc ++ [
                "audio"
                "decrement"
                "5%"
              ];
            };
            "XF86MonBrightnessUp" = {
              _props.allow-when-locked = true;
              spawn = dmsIpc ++ [
                "brightness"
                "increment"
                "5%"
                cfg.backlightDevice
              ];
            };
            "XF86MonBrightnessDown" = {
              _props.allow-when-locked = true;
              spawn = dmsIpc ++ [
                "brightness"
                "decrement"
                "5%"
                cfg.backlightDevice
              ];
            };
            "XF86AudioMute" = {
              _props.repeat = false;
              _props.allow-when-locked = true;
              spawn = dmsIpc ++ [
                "audio"
                "mute"
              ];
            };
            "XF86AudioMicMute" = {
              _props.repeat = false;
              _props.allow-when-locked = true;
              spawn = dmsIpc ++ [
                "audio"
                "micmute"
              ];
            };
            "XF86Tools" = {
              _props.repeat = false;
              spawn = dmsIpc ++ [
                "settings"
                "focusOrToggle"
              ];
            };
            "XF86Display" = {
              _props.repeat = false;
              spawn = dmsIpc ++ [
                "inhibit"
                "toggle"
              ];
            };
            "Super+L".spawn = dmsIpc ++ [
              "lock"
              "lock"
            ];

            "Super+Left".focus-column-left = { };
            "Super+Down".focus-window-down = { };
            "Super+Up".focus-window-up = { };
            "Super+Right".focus-column-right = { };
            "Super+Ctrl+Left".move-column-left = { };
            "Super+Ctrl+Down".move-window-down = { };
            "Super+Ctrl+Up".move-window-up = { };
            "Super+Ctrl+Right".move-column-right = { };

            "Super+Home".focus-column-first = { };
            "Super+End".focus-column-last = { };
            "Super+Ctrl+Home".move-column-to-first = { };
            "Super+Ctrl+End".move-column-to-last = { };

            "Super+Page_Down".focus-workspace-down = { };
            "Super+Page_Up".focus-workspace-up = { };
            "Super+Ctrl+Page_Down".move-column-to-workspace-down = { };
            "Super+Ctrl+Page_Up".move-column-to-workspace-up = { };
            "Super+Shift+Page_Down".move-workspace-down = { };
            "Super+Shift+Page_Up".move-workspace-up = { };

            "Super+BracketLeft".consume-or-expel-window-left = { };
            "Super+BracketRight".consume-or-expel-window-right = { };
            "Super+Comma".consume-window-into-column = { };
            "Super+Period".expel-window-from-column = { };

            "Super+T" = {
              _props.cooldown-ms = 100;
              switch-preset-column-width = { };
            };
            "Super+Shift+T" = {
              _props.cooldown-ms = 100;
              switch-preset-window-height = { };
            };
            "Super+Ctrl+T".reset-window-height = { };
            "Super+F" = {
              _props.repeat = false;
              maximize-column = { };
            };
            "Super+Shift+F" = {
              _props.repeat = false;
              fullscreen-window = { };
            };
            "Super+Ctrl+F".expand-column-to-available-width = { };

            "Super+Minus".set-column-width = "-10%";
            "Super+Equal".set-column-width = "+10%";
            "Super+Shift+Minus".set-window-height = "-10%";
            "Super+Shift+Equal".set-window-height = "+10%";

            "Print".screenshot = {
              _props.show-pointer = false;
            };
            "Ctrl+Print".screenshot-screen = {
              _props.show-pointer = false;
            };
            "Alt+Print".screenshot-window = {
              _props.show-pointer = false;
            };

            "Super+W" = {
              _props.repeat = false;
              toggle-column-tabbed-display = { };
            };
            "Super+V" = {
              _props.repeat = false;
              toggle-window-floating = { };
            };
            "Super+D".center-column = { };
            "Super+C" = {
              _props.cooldown-ms = 100;
              close-window = { };
            };

            "Ctrl+Alt+Delete".quit = { };

            "Mod+Tab" = {
              _props.repeat = false;
              toggle-overview = { };
            };
          }
          // lib.mergeAttrsList (
            map (num: {
              "Super+${toString num}".focus-workspace = num;
              "Super+Control+${toString num}".move-column-to-workspace = num;
            }) (lib.range 1 9)
          )
          // lib.optionalAttrs (terminal != null) {
            "Super+Q" = {
              _props.cooldown-ms = 500;
              spawn = terminal;
            };
          };
      };
  };
}
