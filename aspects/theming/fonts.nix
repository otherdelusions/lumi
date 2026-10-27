{ den, ... }:
{
  den.aspects.theming.includes = [ den.aspects.theming.fonts ];

  den.aspects.theming.fonts = {
    includes = [ den.aspects.theming.options ];

    provides.to-users.homeManager = { config, lib, ... }: {
      home.packages = with config.theme.fonts; [
        monospace.package
        sansSerif.package
        serif.package
      ];

      fonts = {
        fontconfig.enable = true;
        fontconfig.defaultFonts = lib.genAttrs [
          "monospace"
          "serif"
          "sansSerif"
        ] (family: [ config.theme.fonts.${family}.name ]);
      };
    };

    nixos = {
      fonts.enableDefaultPackages = true;
    };
  };
}
