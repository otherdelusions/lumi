{ den, ... }:
{
  den.aspects.theming.includes = [ den.aspects.theming.foot ];

  den.aspects.theming.foot = {
    includes = [ den.aspects.theming.options ];

    provides.to-users.homeManager =
      { config, ... }:
      {
        programs.foot.settings = {
          main = {
            font = "${config.theme.fonts.monospace.name}:size=12";
          };
          "colors-dark" = with config.theme.colors; {
            foreground = base04;
            background = base00;
            cursor = "${base00} ${base07}";
            selection-foreground = base04;
            selection-background = base08;
            search-box-no-match = "${base00} ${base09}";
            search-box-match = "${base00} ${base07}";
            urls = base07;
            regular0 = base00;
            regular1 = base09;
            regular2 = base0F;
            regular3 = base0C;
            regular4 = base07;
            regular5 = base0A;
            regular6 = base07;
            regular7 = base04;
            bright0 = base03;
            bright1 = base0A;
            bright2 = base0E;
            bright3 = base0D;
            bright4 = base07;
            bright5 = base0A;
            bright6 = base07;
            bright7 = base05;
            "16" = base0B;
            "17" = base0D;
            "18" = base01;
            "19" = base02;
            "20" = base04;
            "21" = base05;
          };
        };
      };
  };
}
