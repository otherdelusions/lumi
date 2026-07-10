{
  den.aspects.server = {
    nixos =
      { lib, ... }:
      {
        fonts.fontconfig.enable = lib.mkDefault false;
        xdg.autostart.enable = lib.mkDefault false;
        xdg.icons.enable = lib.mkDefault false;
        xdg.menus.enable = lib.mkDefault false;
        xdg.mime.enable = lib.mkDefault false;
        xdg.sounds.enable = lib.mkDefault false;
      };
  };
}
