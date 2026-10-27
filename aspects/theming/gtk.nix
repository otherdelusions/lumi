{ den, ... }:
{
  den.aspects.theming.includes = [ den.aspects.theming.gtk ];

  den.aspects.theming.gtk = {
    includes = [ den.aspects.theming.options ];

    provides.to-users.homeManager =
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

        inherit (config.theme) colors;

        rgba =
          color: alpha: "rgba(${toString color.r}, ${toString color.g}, ${toString color.b}, ${alpha})";

        gtk3Css = with colors.withHashtag; ''
          @define-color base00 ${base00};
          @define-color base01 ${base01};
          @define-color base02 ${base02};
          @define-color base03 ${base03};
          @define-color base04 ${base04};
          @define-color base05 ${base05};
          @define-color base06 ${base06};
          @define-color base07 ${base07};
          @define-color base08 ${base08};
          @define-color base09 ${base09};
          @define-color base0A ${base0A};
          @define-color base0B ${base0B};
          @define-color base0C ${base0C};
          @define-color base0D ${base0D};
          @define-color base0E ${base0E};
          @define-color base0F ${base0F};

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
          @define-color headerbar_border_color ${rgba colors.withRgb.base01 "0.7"};
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

        gtk4Css = with colors.withHashtag; ''
          :root {
            --base00: ${base00};
            --base01: ${base01};
            --base02: ${base02};
            --base03: ${base03};
            --base04: ${base04};
            --base05: ${base05};
            --base06: ${base06};
            --base07: ${base07};
            --base08: ${base08};
            --base09: ${base09};
            --base0A: ${base0A};
            --base0B: ${base0B};
            --base0C: ${base0C};
            --base0D: ${base0D};
            --base0E: ${base0E};
            --base0F: ${base0F};

            --accent-bg-color: var(--base0D);
            --accent-fg-color: var(--base00);
            --accent-color: var(--base0D);

            --destructive-bg-color: var(--base08);
            --destructive-fg-color: var(--base00);
            --destructive-color: var(--base08);

            --success-bg-color: var(--base0B);
            --success-fg-color: var(--base00);
            --success-color: var(--base0B);

            --warning-bg-color: var(--base0E);
            --warning-fg-color: var(--base00);
            --warning-color: var(--base0E);

            --error-bg-color: var(--base08);
            --error-fg-color: var(--base00);
            --error-color: var(--base08);

            --window-bg-color: var(--base00);
            --window-fg-color: var(--base05);

            --view-bg-color: var(--base00);
            --view-fg-color: var(--base05);

            --headerbar-bg-color: var(--base01);
            --headerbar-fg-color: var(--base05);
            --headerbar-border-color: ${rgba colors.withRgb.base01 "0.7"};
            --headerbar-backdrop-color: var(--base00);
            --headerbar-shade-color: rgba(0, 0, 0, 0.07);
            --headerbar-darker-shade-color: rgba(0, 0, 0, 0.07);

            --sidebar-bg-color: var(--base01);
            --sidebar-fg-color: var(--base05);
            --sidebar-backdrop-color: var(--base00);
            --sidebar-border-color: rgba(0, 0, 0, 0.07);
            --sidebar-shade-color: rgba(0, 0, 0, 0.07);

            --secondary-sidebar-bg-color: var(--base01);
            --secondary-sidebar-fg-color: var(--base05);
            --secondary-sidebar-backdrop-color: var(--base00);
            --secondary-sidebar-border-color: rgba(0, 0, 0, 0.07);
            --secondary-sidebar-shade-color: rgba(0, 0, 0, 0.07);

            --card-bg-color: var(--base01);
            --card-fg-color: var(--base05);
            --card-shade-color: rgba(0, 0, 0, 0.07);

            --overview-bg-color: var(--base01);
            --overview-fg-color: var(--base05);
            --thumbnail-bg-color: var(--base02);
            --thumbnail-fg-color: var(--base05);

            --active-toggle-bg-color: var(--base02);
            --active-toggle-fg-color: var(--base05);

            --dialog-bg-color: var(--base01);
            --dialog-fg-color: var(--base05);

            --popover-bg-color: var(--base01);
            --popover-fg-color: var(--base05);
            --popover-shade-color: rgba(0, 0, 0, 0.07);

            --shade-color: rgba(0, 0, 0, 0.07);
            --scrollbar-outline-color: var(--base02);

            --blue-1: var(--base0D);
            --blue-2: var(--base0D);
            --blue-3: var(--base0D);
            --blue-4: var(--base0D);
            --blue-5: var(--base0D);

            --green-1: var(--base0B);
            --green-2: var(--base0B);
            --green-3: var(--base0B);
            --green-4: var(--base0B);
            --green-5: var(--base0B);

            --yellow-1: var(--base0A);
            --yellow-2: var(--base0A);
            --yellow-3: var(--base0A);
            --yellow-4: var(--base0A);
            --yellow-5: var(--base0A);

            --orange-1: var(--base09);
            --orange-2: var(--base09);
            --orange-3: var(--base09);
            --orange-4: var(--base09);
            --orange-5: var(--base09);

            --red-1: var(--base08);
            --red-2: var(--base08);
            --red-3: var(--base08);
            --red-4: var(--base08);
            --red-5: var(--base08);

            --purple-1: var(--base0E);
            --purple-2: var(--base0E);
            --purple-3: var(--base0E);
            --purple-4: var(--base0E);
            --purple-5: var(--base0E);

            --brown-1: var(--base0F);
            --brown-2: var(--base0F);
            --brown-3: var(--base0F);
            --brown-4: var(--base0F);
            --brown-5: var(--base0F);

            --light-1: var(--base05);
            --light-2: var(--base05);
            --light-3: var(--base05);
            --light-4: var(--base05);
            --light-5: var(--base05);

            --dark-1: var(--base05);
            --dark-2: var(--base05);
            --dark-3: var(--base05);
            --dark-4: var(--base05);
            --dark-5: var(--base05);
          }
        '';
      in
      {
        home.pointerCursor = {
          enable = true;
          inherit (config.theme.cursor) name package size;
          gtk.enable = true;
        };

        home.packages = [ adwaita-colors-morewaita ];

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
          "gtk-3.0/gtk.css".text = gtk3Css;
          "gtk-4.0/gtk.css".text = gtk3Css + gtk4Css;
        };
      };
  };
}
