{
  lib,
  pkgs,
  inputs,
  ...
}:
let
  colors = {
    base00 = "111111";
    base01 = "2e2e2e";
    base02 = "3f3f3f";
    base03 = "7f7f7f";
    base04 = "dbdedf";
    base05 = "ffffff";
    base06 = "0070f0";
    base07 = "00b7f1";
    base08 = "1aebf1";
    base09 = "f4424c";
    base0A = "ff3964";
    base0B = "fb8f05";
    base0C = "f6bc16";
    base0D = "f7e396";
    base0E = "c2fc32";
    base0F = "00ff77";
  };

  fonts = inputs.apple-fonts.packages.${pkgs.stdenv.hostPlatform.system};
in
{
  _module.args.theme = {
    name = "lumi";

    colors = colors // {
      withHashtag = lib.mapAttrs (_: value: "#${value}") colors;
      withRgb = lib.mapAttrs (
        _: color:
        let
          channel = start: lib.fromHexString (builtins.substring start 2 color);
        in
        {
          r = channel 0;
          g = channel 2;
          b = channel 4;
        }
      ) colors;
    };

    fonts = {
      monospace = {
        package = fonts.sf-mono-nerd;
        name = "SFMono Nerd Font";
      };
      sansSerif = {
        package = fonts.sf-pro-nerd;
        name = "SFProDisplay Nerd Font";
      };
      serif = {
        package = fonts.ny-nerd;
        name = "New York Nerd Font";
      };
    };

    wallPaper = "${../../../../config/wallpaper}/aeternum.png";

    cursor = {
      name = "Adwaita";
      package = pkgs.adwaita-icon-theme;
      size = 24;
    };
  };
}
