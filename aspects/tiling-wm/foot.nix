{ den, ... }:
{
  den.aspects.tiling-wm.includes = [ den.aspects.tiling-wm.foot ];

  den.aspects.tiling-wm.foot = {
    provides.to-users.homeManager =
      { host, ... }:
      {
        programs.foot = {
          enable = host.desktop.compositor != null;
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
      };
  };
}
