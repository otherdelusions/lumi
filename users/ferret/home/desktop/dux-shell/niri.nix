{ config, ... }: {
  programs.dux-shell.settings.dmsWindowsFloatingSeeded = [ "niri" ];

  wayland.windowManager.niri.extraConfig = ''
    include optional=true "${config.xdg.configHome}/niri/dms/alttab.kdl"
    include optional=true "${config.xdg.configHome}/niri/dms/colors.kdl"
    include optional=true "${config.xdg.configHome}/niri/dms/layout.kdl"
    include optional=true "${config.xdg.configHome}/niri/dms/windowrules.kdl"
  '';
}
