{ den, ... }:
{
  den.aspects.theming.includes = [ den.aspects.theming.foot ];

  den.aspects.theming.foot = {
    includes = [ den.aspects.theming.options ];

    provides.to-users.homeManager =
      { config, ... }:
      let
        inherit (config.theme) colors;
      in
      {
        programs.foot.settings = {
          main = {
            font = "${config.theme.fonts.monospace.name}:size=12";
            dpi-aware = "no";
            initial-color-theme = "dark";
          };
          "colors-dark" = {
            alpha = 1.0;
            foreground = colors.base05;
            background = colors.base00;
            cursor = "${colors.base00} ${colors.base07}";
            regular0 = colors.base00;
            regular1 = colors.base08;
            regular2 = colors.base0B;
            regular3 = colors.base0A;
            regular4 = colors.base0D;
            regular5 = colors.base0E;
            regular6 = colors.base0C;
            regular7 = colors.base05;
            bright0 = colors.base03;
            bright1 = colors.base08;
            bright2 = colors.base0B;
            bright3 = colors.base0A;
            bright4 = colors.base0D;
            bright5 = colors.base0E;
            bright6 = colors.base0C;
            bright7 = colors.base07;
            "16" = colors.base09;
            "17" = colors.base0F;
            "18" = colors.base01;
            "19" = colors.base02;
            "20" = colors.base04;
            "21" = colors.base06;
          };
        };
      };
  };
}
