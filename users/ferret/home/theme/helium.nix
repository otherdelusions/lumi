{
  config,
  theme,
  # lib,
  ...
}:
{
  imports = [ ./palette.nix ];

  programs.helium.commandLineArgs = [
    "--load-extension=${config.xdg.configHome}/helium-theme"
  ];

  programs.helium.preferences.webkit.webprefs = {
    fonts = with theme.fonts; {
      standard.Zyyy = serif.name;
      serif.Zyyy = serif.name;
      sansserif.Zyyy = sansSerif.name;
      fixed.Zyyy = monospace.name;
    };

    default_font_size = 16;
    default_fixed_font_size = 16;
  };

  xdg.configFile = {
    "helium-theme/manifest.json".text = builtins.toJSON {
      manifest_version = 3;
      inherit (theme) name;
      version = "1.0";

      theme.colors = with theme.colors.withRgb; {
        frame = base00;
        frame_inactive = base00;
        toolbar = base01;
        toolbar_text = base04;
        toolbar_button_icon = base04;
        tab_text = base05;
        tab_background_text = base04;
        omnibox_background = base00;
        omnibox_text = base04;
        ntp_background = base00;
        ntp_text = base04;
        ntp_link = base07;
      };
    };
  };

  # programs.helium.preferences = {
  #   browser.theme = {
  #     user_color2 = lib.fromHexString "ff${theme.colors.base00}" - 4294967296; # to int32
  #     color_variant2 = 3;
  #   };
  # };

  # programs.helium.preferences.extensions.theme = {
  #   id = "user_color_theme_id";
  # };
}
