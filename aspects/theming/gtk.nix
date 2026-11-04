{ den, ... }:
{
  den.aspects.theming.includes = [ den.aspects.theming.gtk ];

  den.aspects.theming.gtk = {
    includes = [ den.aspects.theming.options ];

    provides.to-users.homeManager =
      {
        config,
        lib,
        pkgs,
        self',
        ...
      }:
      let
        colors = config.theme.colors.withHashtag;
        adwaita-colors-morewaita = self'.packages.morewaita-accent-icon-theme.override {
          accentColor = colors.base07;
        };

        gtkColors = with colors; {
          accent_color = base07;
          accent_bg_color = base06;
          accent_fg_color = base05;
          destructive_color = base09;
          destructive_bg_color = base09;
          destructive_fg_color = base00;
          success_color = base0F;
          success_bg_color = base0F;
          success_fg_color = base00;
          warning_color = base0C;
          warning_bg_color = base0C;
          warning_fg_color = base00;
          error_color = base09;
          error_bg_color = base09;
          error_fg_color = base00;
          window_bg_color = base00;
          window_fg_color = base04;
          view_bg_color = base00;
          view_fg_color = base04;
          headerbar_bg_color = base01;
          headerbar_fg_color = base05;
          headerbar_border_color = base02;
          headerbar_backdrop_color = base00;
          headerbar_shade_color = "rgba(0, 0, 0, 0.16)";
          headerbar_darker_shade_color = "rgba(0, 0, 0, 0.22)";
          sidebar_bg_color = base01;
          sidebar_fg_color = base05;
          sidebar_backdrop_color = base00;
          sidebar_shade_color = "rgba(0, 0, 0, 0.16)";
          secondary_sidebar_bg_color = base02;
          secondary_sidebar_fg_color = base05;
          secondary_sidebar_backdrop_color = base00;
          secondary_sidebar_shade_color = "rgba(0, 0, 0, 0.16)";
          card_bg_color = base01;
          card_fg_color = base05;
          card_shade_color = "rgba(0, 0, 0, 0.16)";
          overview_bg_color = base00;
          overview_fg_color = base05;
          thumbnail_bg_color = base02;
          thumbnail_fg_color = base05;
          active_toggle_bg_color = base08;
          active_toggle_fg_color = base05;
          dialog_bg_color = base02;
          dialog_fg_color = base05;
          popover_bg_color = base02;
          popover_fg_color = base05;
          popover_shade_color = "rgba(0, 0, 0, 0.16)";
          shade_color = "rgba(0, 0, 0, 0.16)";
          scrollbar_outline_color = base03;
        };

        gtk3Css = lib.concatStringsSep "\n" (
          lib.mapAttrsToList (name: value: "@define-color ${name} ${value};") gtkColors
        );

        gtk4Css = ''
          :root {
            ${lib.concatStringsSep "\n" (
              lib.mapAttrsToList (
                name: value: "--${lib.replaceStrings [ "_" ] [ "-" ] name}: ${value};"
              ) gtkColors
            )}
          }
        '';

        selectionCss = with colors; ''
          selection,
          row:selected {
            background-color: ${base08};
            color: ${base05};
          }

          scale trough,
          progressbar trough {
            background-color: ${base08};
          }

          scale highlight,
          progressbar progress {
            background-color: ${base07};
          }
        '';
      in
      {
        home.pointerCursor = {
          enable = true;
          inherit (config.theme.cursor) name package size;
          gtk.enable = true;
        };

        dconf.settings."org/gnome/desktop/interface".color-scheme = "prefer-dark";

        gtk = {
          enable = true;

          theme = {
            package = pkgs.adw-gtk3;
            name = "adw-gtk3-dark";
          };

          font = {
            inherit (config.theme.fonts.sansSerif) package name;
            size = 12;
          };

          iconTheme = {
            package = adwaita-colors-morewaita;
            name = "Adwaita-accent";
          };

          gtk3.extraConfig.gtk-application-prefer-dark-theme = true;
          gtk4.theme = config.gtk.theme;
        };

        xdg.configFile = {
          "gtk-3.0/gtk.css".text = gtk3Css + "\n" + selectionCss;
          "gtk-4.0/gtk.css".text = gtk3Css + "\n" + gtk4Css + selectionCss;
        };
      };
  };
}
