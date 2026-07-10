{ den, ... }:
{
  den.aspects.graphical.includes = [ den.aspects.graphical.graphics ];

  den.aspects.graphical.graphics = {
    nixos =
      { pkgs, ... }:
      {
        hardware.graphics.enable = true;

        hardware.graphics.extraPackages = with pkgs; [
          intel-media-driver
          intel-vaapi-driver
        ];
      };
  };
}
