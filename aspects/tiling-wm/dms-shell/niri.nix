{ den, ... }:
{
  den.aspects.tiling-wm.dms-shell.includes = [ den.aspects.tiling-wm.dms-shell.niri ];

  den.aspects.tiling-wm.dms-shell.niri = {
    homeManager = { config, ... }: {
      wayland.windowManager.niri.extraConfig = ''
        include optional=true "${config.xdg.configHome}/niri/dms/alttab.kdl"
        include optional=true "${config.xdg.configHome}/niri/dms/colors.kdl"
        include optional=true "${config.xdg.configHome}/niri/dms/layout.kdl"
      '';
    };
  };
}
