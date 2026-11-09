{
  imports = [
    ./base.nix
    ./binds.nix
    ./env.nix
  ];

  wayland.windowManager.niri = {
    enable = true;
    xwaylandSatellitePackage = null;
  };
}
