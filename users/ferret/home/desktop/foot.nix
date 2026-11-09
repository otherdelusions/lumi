{
  config,
  lib,
  ...
}:
{
  xdg.desktopEntries.helix-terminal = {
    name = "Helix";
    icon = "helix";
    exec = "${lib.getExe config.programs.foot.package} -e hx %F";
    type = "Application";
    noDisplay = true;
    terminal = false;
  };

  programs.foot = {
    enable = true;
    settings = {
      main = {
        pad = "15x15";
      };

      cursor = {
        style = "beam";
        blink = "no";
      };
    };
  };
}
