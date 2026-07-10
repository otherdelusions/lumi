{ den, inputs, ... }:
{
  den.aspects.tiling-wm.includes = [ den.aspects.tiling-wm.dms-shell ];

  den.aspects.tiling-wm.dms-shell = {
    homeManager =
      { host, ... }:
      {
        imports = [
          inputs.dms.homeModules.dank-material-shell
        ];

        programs.dank-material-shell = {
          enable = host.desktop.compositor != null;

          systemd = {
            enable = true;
            restartIfChanged = true;
          };
        };
      };
  };
}
