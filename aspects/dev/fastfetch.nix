{ den, ... }:
{
  den.aspects.dev.includes = [ den.aspects.dev.fastfetch ];

  den.aspects.dev.fastfetch = {
    homeManager = {
      programs.fastfetch = {
        enable = true;

        settings = {
          display = {
            size = {
              maxPrefix = "MB";
              ndigits = 0;
              spaceBeforeUnit = "never";
            };
            freq = {
              ndigits = 3;
              spaceBeforeUnit = "never";
            };
          };

          modules = [
            "title"
            "separator"
            "os"
            "host"
            {
              type = "kernel";
              format = "{release}";
            }
            "uptime"
            {
              type = "packages";
              combined = true;
            }
            "shell"
            "wm"
            "cpu"
            {
              type = "gpu";
              key = "GPU";
              format = "{name}";
            }
            {
              type = "memory";
              format = "{used} / {total}";
            }
            "break"
            "colors"
          ];
        };
      };
    };
  };
}
