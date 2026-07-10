{ den, ... }:
{
  den.aspects.graphical.includes = [ den.aspects.graphical.fonts ];

  den.aspects.graphical.fonts = {
    nixos =
      { pkgs, ... }:
      {
        fonts.enableDefaultPackages = true;

        fonts.packages = with pkgs; [
          noto-fonts
          noto-fonts-cjk-sans
          nerd-fonts.roboto-mono
        ];
      };
  };
}
