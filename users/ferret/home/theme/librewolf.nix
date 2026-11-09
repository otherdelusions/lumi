{
  theme,
  inputs,
  pkgs,
  ...
}:
let
  inherit (inputs.nur.legacyPackages.${pkgs.stdenv.hostPlatform.system}.repos.rycee) firefox-addons;
in
{
  imports = [ ./palette.nix ];

  programs.librewolf.profiles.ferret = {
    settings = {
      "font.name.monospace.x-western" = theme.fonts.monospace.name;
      "font.name.sans-serif.x-western" = theme.fonts.sansSerif.name;
      "font.name.serif.x-western" = theme.fonts.serif.name;
      "font.size.monospace.x-western" = 16;
      "font.size.variable.x-western" = 16;
    };

    extensions = {
      packages = [ firefox-addons.firefox-color ];

      settings."FirefoxColor@mozilla.com".settings = {
        firstRunDone = true;

        theme = {
          title = theme.name;

          colors = with theme.colors.withRgb; {
            toolbar = base01;
            toolbar_text = base04;
            frame = base00;
            tab_background_text = base04;
            toolbar_field = base00;
            toolbar_field_text = base04;
            tab_line = base07;
            popup = base01;
            popup_text = base04;
            button_background_hover = base02;
            button_background_active = base02;
            frame_inactive = base00;
            icons_attention = base07;
            icons = base04;
            ntp_background = base00;
            ntp_text = base04;
            popup_border = base02;
            popup_highlight_text = base05;
            popup_highlight = base02;
            sidebar_border = base02;
            sidebar_highlight_text = base05;
            sidebar_highlight = base02;
            sidebar_text = base04;
            sidebar = base01;
            tab_loading = base07;
            tab_selected = base07;
            tab_text = base00;
            toolbar_bottom_separator = base02;
            toolbar_field_border_focus = base07;
            toolbar_field_border = base02;
            toolbar_field_highlight_text = base05;
            toolbar_field_highlight = base02;
            toolbar_vertical_separator = base02;
          };
        };
      };
    };
  };
}
