{ theme, lib, ... }: {
  imports = [ ./palette.nix ];

  home.packages = with theme.fonts; [
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
    ] (family: [ theme.fonts.${family}.name ]);
  };
}
