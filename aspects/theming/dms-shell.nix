{ den, ... }:
{
  den.aspects.theming.includes = [ den.aspects.theming.dms-shell ];

  den.aspects.theming.dms-shell = {
    homeManager =
      {
        config,
        lib,
        pkgs,
        ...
      }:
      lib.mkIf (config.programs ? dank-material-shell) {
        programs.dank-material-shell.session = lib.mkIf (config.theme.wallPaper != null) {
          wallpaperPath = config.theme.wallPaper;
          wallpaperPathLight = config.theme.wallPaper;
          wallpaperPathDark = config.theme.wallPaper;
        };

        programs.dank-material-shell.settings = {
          fontFamily = config.theme.fonts.sansSerif.name;
          monoFontFamily = config.theme.fonts.monospace.name;
          greeterFontFamily = config.theme.fonts.sansSerif.name;
          fontScale = 1.14;

          currentThemeName = "custom";
          customThemeFile = lib.mkForce (
            let
              inherit (config.theme) colors;
              theme = with colors.withHashtag; {
                inherit (config.theme) name;
                primary = base0B;
                primaryText = base00;
                primaryContainer = base0C;
                secondary = base09;
                surface = base00;
                surfaceText = base05;
                surfaceVariant = base00;
                surfaceVariantText = base05;
                surfaceTint = base0D;
                background = base00;
                backgroundText = base06;
                outline = base03;
                surfaceContainer = base00;
                surfaceContainerHigh = base01;
                surfaceContainerHighest = base02;
                error = base08;
                warning = base0A;
                info = base0C;
              };
            in
            pkgs.writeText "dankMaterialShell-${config.theme.name}-color-theme.json" (
              lib.toJSON {
                dark = theme;
                light = theme;
              }
            )
          );
        };
      };
  };
}
