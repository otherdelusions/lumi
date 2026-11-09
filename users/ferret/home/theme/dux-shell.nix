{
  theme,
  lib,
  pkgs,
  self,
  ...
}:
{
  imports = [
    ./palette.nix
    self.homeManagerModules.dux-shell
  ];

  programs = {
    dux-shell.session.wallpaperPath = theme.wallPaper;

    dux-shell.settings = {
      fontFamily = theme.fonts.sansSerif.name;
      monoFontFamily = theme.fonts.monospace.name;
      fontScale = 1.14;

      currentThemeName = "custom";
      customThemeFile = pkgs.writeText "dux-shell-${theme.name}-color-theme.json" (
        lib.toJSON (
          with theme.colors.withHashtag;
          {
            inherit (theme) name;
            primary = base08; # active controls (volume fill, toggle)
            primaryText = base00;
            primaryContainer = base07;
            secondary = base07; # secondary fills (unchosen options, unfilled slider track)
            tertiary = base08; # supporting accents (secondary chart lines)

            containerTint = 1; # buttons, clock card
            selectedContainerTint = 0; # selected rows

            background = base00;
            backgroundText = base04;
            surface = base00; # panels (launcher, settings, control center)
            surfaceText = base04; # main text and icons (titles, button labels)
            surfaceContainerLowest = "#0b0b0b";
            surfaceContainerLow = "#202020";
            surfaceContainer = base01;
            surfaceContainerHigh = base02;
            surfaceContainerHighest = "#505050";
            surfaceVariant = base02; # overlays
            surfaceVariantText = base04; # secondary text (setting descriptions)
            surfaceTint = base08;
            outline = base03;

            error = base0A;
            errorText = base00;
            warning = base0C;
            info = base07;
            success = base0F;

            accents = {
              red = base09;
              orange = base0B;
              yellow = base0C;
              green = base0E;
              teal = base0F;
              blue = base07;
              purple = base08;
              pink = base0A;
            };
          }
        )
      );
    };
  };
}
