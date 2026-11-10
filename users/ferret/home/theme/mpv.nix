{ theme, ... }:
{
  programs.mpv = {
    config = with theme.colors.withHashtag; {
      osd-font = theme.fonts.sansSerif.name;
      sub-font = theme.fonts.sansSerif.name;

      background-color = base00;
      osd-back-color = base01;
      osd-border-color = base01;
      osd-color = base05;
      osd-shadow-color = base00;
    };

    scriptOpts = {
      modernz = with theme.colors.withHashtag; {
        seekbarfg_color = base07;
        seekbarbg_color = base02;
        seekbar_cache_color = base03;
        window_title_color = base03;
        window_controls_color = base02;

        title_color = base05;
        time_color = base05;
        chapter_title_color = base05;
        cache_info_color = base05;

        middle_buttons_color = base04;
        side_buttons_color = base03;
        playpause_color = base04;
        hover_effect_color = base08;
        seek_handle_color = base06;
        seek_handle_border_color = "disable";
        volumebar_match_seek_color = true;
        hover_effect = "glow,color,box";
        layout = "compact";
        icon_theme = "material";
        icon_style = "filled";
      };
    };
  };
}
