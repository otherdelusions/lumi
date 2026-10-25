{ config, lib, ... }: {
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
}
