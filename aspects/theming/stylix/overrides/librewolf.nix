{ den, ... }:
{
  den.aspects.theming.stylix.includes = [ den.aspects.theming.stylix.librewolf ];

  den.aspects.theming.stylix.librewolf = {
    homeManager =
      { lib, config, ... }:
      let
        cfg = config.stylix.targets.librewolf;
        inherit (config.lib.stylix) colors;
        mkColor = color: {
          r = colors."${color}-rgb-r";
          g = colors."${color}-rgb-g";
          b = colors."${color}-rgb-b";
        };
      in
      {
        stylix.targets.librewolf = lib.mkIf config.programs.librewolf.enable {
          colorTheme.enable = true;
          profileNames = [ "default" ];
        };

        programs.librewolf.profiles = lib.mkIf (cfg.enable && cfg.colorTheme.enable) (
          lib.genAttrs cfg.profileNames (_: {
            extensions.settings."FirefoxColor@mozilla.com".settings.theme.colors = lib.mkForce {
              toolbar = mkColor "base00";
              toolbar_text = mkColor "base05";
              frame = mkColor "base01";
              tab_background_text = mkColor "base05";
              toolbar_field = mkColor "base02";
              toolbar_field_text = mkColor "base05";
              tab_line = mkColor "base0D";
              popup = mkColor "base00";
              popup_text = mkColor "base05";
              button_background_active = mkColor "base03";
              frame_inactive = mkColor "base00";
              icons_attention = mkColor "base0D";
              icons = mkColor "base05";
              ntp_background = mkColor "base00";
              ntp_text = mkColor "base05";
              popup_border = mkColor "base0D";
              popup_highlight_text = mkColor "base00";
              popup_highlight = mkColor "base0B";
              sidebar_border = mkColor "base0D";
              sidebar_highlight_text = mkColor "base05";
              sidebar_highlight = mkColor "base0D";
              sidebar_text = mkColor "base05";
              sidebar = mkColor "base00";
              tab_background_separator = mkColor "base0D";
              tab_loading = mkColor "base05";
              tab_selected = mkColor "base00";
              tab_text = mkColor "base05";
              toolbar_bottom_separator = mkColor "base00";
              toolbar_field_border_focus = mkColor "base0D";
              toolbar_field_border = mkColor "base00";
              toolbar_field_focus = mkColor "base00";
              toolbar_field_highlight_text = mkColor "base00";
              toolbar_field_highlight = mkColor "base0D";
              toolbar_field_separator = mkColor "base0D";
              toolbar_vertical_separator = mkColor "base0D";
            };
          })
        );
      };
  };
}
