{ den, ... }:
{
  den.aspects.tiling-wm.niri.includes = [ den.aspects.tiling-wm.niri.env ];

  den.aspects.tiling-wm.niri.env = {
    homeManager =
      { lib, ... }:
      {
        programs.niri.settings.environment = {
          QT_QPA_PLATFORM = lib.mkDefault "wayland";
          WINIT_UNIX_BACKEND = lib.mkDefault "wayland";
          WLR_NO_HARDWARE_CURSORS = lib.mkDefault "1";
          NIXOS_OZONE_WL = lib.mkDefault "1";
          GTK_USE_PORTAL = lib.mkDefault "1";
        };
      };
  };
}
