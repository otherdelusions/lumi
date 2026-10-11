{ den, ... }:
{
  den.aspects.theming.includes = [ den.aspects.theming.gtk ];

  den.aspects.theming.gtk = {
    homeManager =
      {
        config,
        pkgs,
        self',
        ...
      }:
      let
        adwaita-colors-morewaita = self'.packages.morewaita-accent-icon-theme.override {
          accentColor = "${config.theme.colors.withHashtag.base0B}";
        };

        colors = config.theme.colors.withHashtag;

        css = ''
          @define-color base00 ${colors.base00};
          @define-color base01 ${colors.base01};
          @define-color base02 ${colors.base02};
          @define-color base03 ${colors.base03};
          @define-color base04 ${colors.base04};
          @define-color base05 ${colors.base05};
          @define-color base06 ${colors.base06};
          @define-color base07 ${colors.base07};
          @define-color base08 ${colors.base08};
          @define-color base09 ${colors.base09};
          @define-color base0A ${colors.base0A};
          @define-color base0B ${colors.base0B};
          @define-color base0C ${colors.base0C};
          @define-color base0D ${colors.base0D};
          @define-color base0E ${colors.base0E};
          @define-color base0F ${colors.base0F};

          @define-color accent_color @base0D;
          @define-color accent_bg_color @base0D;
          @define-color accent_fg_color @base00;

          @define-color destructive_color @base08;
          @define-color destructive_bg_color @base08;
          @define-color destructive_fg_color @base00;

          @define-color success_color @base0B;
          @define-color success_bg_color @base0B;
          @define-color success_fg_color @base00;

          @define-color warning_color @base0E;
          @define-color warning_bg_color @base0E;
          @define-color warning_fg_color @base00;

          @define-color error_color @base08;
          @define-color error_bg_color @base08;
          @define-color error_fg_color @base00;

          @define-color window_bg_color @base00;
          @define-color window_fg_color @base05;

          @define-color view_bg_color @base00;
          @define-color view_fg_color @base05;

          @define-color headerbar_bg_color @base01;
          @define-color headerbar_fg_color @base05;
          @define-color headerbar_border_color alpha(@base01, 0.7);
          @define-color headerbar_backdrop_color @window_bg_color;
          @define-color headerbar_shade_color rgba(0, 0, 0, 0.07);
          @define-color headerbar_darker_shade_color rgba(0, 0, 0, 0.07);

          @define-color sidebar_bg_color @base01;
          @define-color sidebar_fg_color @base05;
          @define-color sidebar_backdrop_color @window_bg_color;
          @define-color sidebar_shade_color rgba(0, 0, 0, 0.07);

          @define-color secondary_sidebar_bg_color @sidebar_bg_color;
          @define-color secondary_sidebar_fg_color @sidebar_fg_color;
          @define-color secondary_sidebar_backdrop_color @sidebar_backdrop_color;
          @define-color secondary_sidebar_shade_color @sidebar_shade_color;

          @define-color card_bg_color @base01;
          @define-color card_fg_color @base05;
          @define-color card_shade_color rgba(0, 0, 0, 0.07);

          @define-color dialog_bg_color @base01;
          @define-color dialog_fg_color @base05;

          @define-color popover_bg_color @base01;
          @define-color popover_fg_color @base05;
          @define-color popover_shade_color rgba(0, 0, 0, 0.07);

          @define-color shade_color rgba(0, 0, 0, 0.07);
          @define-color scrollbar_outline_color @base02;

          @define-color blue_1 @base0D;
          @define-color blue_2 @base0D;
          @define-color blue_3 @base0D;
          @define-color blue_4 @base0D;
          @define-color blue_5 @base0D;

          @define-color green_1 @base0B;
          @define-color green_2 @base0B;
          @define-color green_3 @base0B;
          @define-color green_4 @base0B;
          @define-color green_5 @base0B;

          @define-color yellow_1 @base0A;
          @define-color yellow_2 @base0A;
          @define-color yellow_3 @base0A;
          @define-color yellow_4 @base0A;
          @define-color yellow_5 @base0A;

          @define-color orange_1 @base09;
          @define-color orange_2 @base09;
          @define-color orange_3 @base09;
          @define-color orange_4 @base09;
          @define-color orange_5 @base09;

          @define-color red_1 @base08;
          @define-color red_2 @base08;
          @define-color red_3 @base08;
          @define-color red_4 @base08;
          @define-color red_5 @base08;

          @define-color purple_1 @base0E;
          @define-color purple_2 @base0E;
          @define-color purple_3 @base0E;
          @define-color purple_4 @base0E;
          @define-color purple_5 @base0E;

          @define-color brown_1 @base0F;
          @define-color brown_2 @base0F;
          @define-color brown_3 @base0F;
          @define-color brown_4 @base0F;
          @define-color brown_5 @base0F;

          @define-color light_1 @base05;
          @define-color light_2 @base05;
          @define-color light_3 @base05;
          @define-color light_4 @base05;
          @define-color light_5 @base05;

          @define-color dark_1 @base05;
          @define-color dark_2 @base05;
          @define-color dark_3 @base05;
          @define-color dark_4 @base05;
          @define-color dark_5 @base05;
        '';
      in
      {
        home.pointerCursor = {
          enable = true;
          inherit (config.theme.cursor) name package size;
          gtk.enable = true;
        };

        home.packages = [
          adwaita-colors-morewaita
          pkgs.morewaita-icon-theme
        ];

        gtk = {
          enable = true;

          theme = {
            package = pkgs.adw-gtk3;
            name = "adw-gtk3";
          };

          font = {
            inherit (config.theme.fonts.sansSerif) package name;
            size = 12;
          };

          iconTheme = {
            package = adwaita-colors-morewaita;
            name = "Adwaita-accent";
          };

          gtk4.theme = config.gtk.theme;
        };

        xdg.configFile = {
          "gtk-3.0/gtk.css".text = css;
          "gtk-4.0/gtk.css".text = css;
        };
      };
  };
}
