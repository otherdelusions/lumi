{ den, ... }:
{
  den.aspects.theming.stylix.includes = [ den.aspects.theming.stylix.dms-shell ];

  den.aspects.theming.stylix.dms-shell = {
    homeManager =
      {
        config,
        lib,
        pkgs,
        ...
      }:
      lib.mkIf (config.programs ? dank-material-shell && config.programs.dank-material-shell.enable) {
        programs.dank-material-shell.settings = {
          greeterFontFamily = config.stylix.fonts.sansSerif.name;
          fontScale = 1.14;

          customThemeFile = lib.mkForce (
            let
              inherit (config.lib.stylix) colors;
              theme = with colors.withHashtag; {
                name = "Stylix";
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
            pkgs.writeText "dankMaterialShell-stylix-color-theme.json" (
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
