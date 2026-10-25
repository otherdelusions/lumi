{
  imports = [
    ./foot.nix
    ./user-dirs.nix
    ./librewolf.nix
    ./theme
    ./niri/base.nix
    ./niri/binds.nix
    ./niri/env.nix
    ./dms/module.nix
    ./dms/settings.nix
    ./dms/niri.nix
  ];
  wayland.windowManager.niri = {
    enable = true;
    xwaylandSatellitePackage = null;
  };
}
