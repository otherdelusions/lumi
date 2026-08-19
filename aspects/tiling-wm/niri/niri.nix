{ den, ... }:
{
  den.aspects.tiling-wm.includes = [ den.aspects.tiling-wm.niri ];

  den.aspects.tiling-wm.niri = {
    nixos =
      {
        pkgs,
        lib,
        config,
        ...
      }:
      {
        programs.niri.enable = true;

        services.gnome.gcr-ssh-agent.enable = false;

        environment.systemPackages = lib.optionals config.programs.niri.enable [
          pkgs.wl-clipboard
        ];
      };

    homeManager = {
      wayland.windowManager.niri = {
        enable = true;
        xwaylandSatellitePackage = null;
      };
    };
  };
}
