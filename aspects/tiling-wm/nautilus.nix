{ den, ... }:
{
  den.aspects.tiling-wm.includes = [ den.aspects.tiling-wm.nautilus ];

  den.aspects.tiling-wm.nautilus = {
    nixos =
      {
        host,
        pkgs,
        lib,
        ...
      }:
      let
        compositor = host.desktop.compositor;
        terminal = host.desktop.terminal;
      in
      {
        environment.systemPackages = with pkgs; [
          nautilus
          ffmpegthumbnailer
        ];

        services.gvfs.enable = true;

        programs.nautilus-open-any-terminal = lib.mkIf (terminal != null) {
          enable = lib.mkDefault true;
          inherit terminal;
        };

        xdg.portal = {
          enable = true;
          config = lib.mkIf (compositor != null) {
            ${compositor} = {
              default = [
                "gnome"
                "gtk"
              ];
              "org.freedesktop.impl.portal.Access" = "gtk";
              "org.freedesktop.impl.portal.FileChooser" = "gnome";
              "org.freedesktop.impl.portal.Notification" = "gtk";
              "org.freedesktop.impl.portal.Secret" = "gnome-keyring";
            };
          };
          extraPortals = [ pkgs.xdg-desktop-portal-gnome ];
        };

        environment.variables.GTK_USE_PORTAL = lib.mkDefault "1";
      };

    homeManager =
      { lib, config, ... }:
      {
        xdg.userDirs.enable = lib.mkDefault true;
        xdg.userDirs.setSessionVariables = lib.mkDefault true;

        home.file =
          let
            inherit (config.xdg.userDirs) templates;
          in
          {
            "${templates}/Empty Text.txt".text = "";
          };
      };
  };
}
