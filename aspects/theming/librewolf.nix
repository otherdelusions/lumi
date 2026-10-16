{ den, ... }:
{
  den.aspects.theming.includes = [ den.aspects.theming.librewolf ];

  den.aspects.theming.librewolf = {
    homeManager =
      {
        lib,
        config,
        inputs',
        ...
      }:
      let
        inherit (config.theme) fonts;
        inherit (inputs'.nur.legacyPackages.repos.rycee) firefox-addons;
      in
      {
        programs.librewolf.profiles = lib.genAttrs config.theme.browser.librewolf.profileNames (_: {
          settings = {
            "font.name.monospace.x-western" = fonts.monospace.name;
            "font.name.sans-serif.x-western" = fonts.sansSerif.name;
            "font.name.serif.x-western" = fonts.serif.name;
            "font.size.monospace.x-western" = 16;
            "font.size.variable.x-western" = 16;
          };

          extensions = {
            packages = [ firefox-addons.firefox-color ];

            settings."FirefoxColor@mozilla.com".settings = {
              firstRunDone = true;

              theme = {
                title = config.theme.name;

                colors = with config.theme.colors.withRgb; {
                  toolbar = base00;
                  toolbar_text = base05;
                  frame = base01;
                  tab_background_text = base05;
                  toolbar_field = base02;
                  toolbar_field_text = base05;
                  tab_line = base0D;
                  popup = base00;
                  popup_text = base05;
                  button_background_active = base03;
                  frame_inactive = base00;
                  icons_attention = base0D;
                  icons = base05;
                  ntp_background = base00;
                  ntp_text = base05;
                  popup_border = base0D;
                  popup_highlight_text = base00;
                  popup_highlight = base0B;
                  sidebar_border = base0D;
                  sidebar_highlight_text = base05;
                  sidebar_highlight = base0D;
                  sidebar_text = base05;
                  sidebar = base00;
                  tab_background_separator = base0D;
                  tab_loading = base05;
                  tab_selected = base00;
                  tab_text = base05;
                  toolbar_bottom_separator = base00;
                  toolbar_field_border_focus = base0D;
                  toolbar_field_border = base00;
                  toolbar_field_focus = base00;
                  toolbar_field_highlight_text = base00;
                  toolbar_field_highlight = base0D;
                  toolbar_field_separator = base0D;
                  toolbar_vertical_separator = base0D;
                };
              };
            };
          };
        });
      };
  };
}
