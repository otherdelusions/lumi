{ den, inputs, ... }:
{
  den.aspects.tiling-wm.dms-shell.includes = [ den.aspects.tiling-wm.dms-shell.niri ];

  den.aspects.tiling-wm.dms-shell.niri = {
    homeManager =
      { osConfig, ... }:
      {
        imports = [ inputs.dms.homeModules.niri ];

        programs.dank-material-shell.niri.includes = {
          enable = osConfig.programs.niri.enable;
          override = true;
          originalFileName = "niri-flake";
          filesToInclude = [
            "alttab"
            "colors"
            "layout"
          ];
        };
      };
  };
}
