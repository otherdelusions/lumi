{ den, ... }:
{
  den.aspects.theming.stylix.includes = [ den.aspects.theming.stylix.gtk ];

  den.aspects.theming.stylix.gtk = {
    homeManager =
      {
        config,
        pkgs,
        self',
        ...
      }:
      let
        adwaita-colors-morewaita = self'.packages.morewaita-stylix-icon-theme.override {
          accentColor = "${config.lib.stylix.colors.withHashtag.base0B}";
        };
      in
      {
        home.packages = [
          adwaita-colors-morewaita
          pkgs.morewaita-icon-theme
          pkgs.adw-gtk3
        ];

        stylix.icons = {
          enable = true;
          dark = "Adwaita-stylix";
          light = "Adwaita-stylix";
        };

        stylix.targets.gtksourceview.enable = false;
      };

    nixos = {
      stylix.targets.gtksourceview.enable = false;
    };
  };
}
