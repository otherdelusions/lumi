{ den, inputs, ... }:
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
        imports = [ inputs.niri.nixosModules.niri ];

        nixpkgs.overlays = [ inputs.niri.overlays.niri ];

        programs.niri = {
          enable = true;
          package = pkgs.niri-unstable;
        };

        xdg.portal =
          let
            portalpkgs = with pkgs; [
              xdg-desktop-portal-gnome
              xdg-desktop-portal-gtk
            ];
          in
          {
            enable = true;
            config.niri = {
              default = [
                "gnome"
                "gtk"
              ];
              "org.freedesktop.impl.portal.Access" = "gtk";
              "org.freedesktop.impl.portal.FileChooser" = "gnome";
              "org.freedesktop.impl.portal.Notification" = "gtk";
            };
            extraPortals = portalpkgs;
            configPackages = portalpkgs;
          };

        services.gnome.gcr-ssh-agent.enable = false;

        environment.systemPackages = lib.optionals config.programs.niri.enable [
          pkgs.wl-clipboard
        ];
      };
  };
}
