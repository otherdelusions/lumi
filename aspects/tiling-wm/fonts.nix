{ den, ... }:
{
  den.aspects.tiling-wm.includes = [ den.aspects.tiling-wm.fonts ];

  den.aspects.tiling-wm.fonts = {
    nixos = { pkgs, ... }: {
      fonts.enableDefaultPackages = true;

      fonts.packages = with pkgs; [
        noto-fonts
        noto-fonts-cjk-sans
      ];
    };
  };
}
