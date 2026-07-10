{
  den.aspects.graphical = {
    nixos =
      { pkgs, ... }:
      {
        environment.systemPackages = with pkgs; [
          croc
          loupe
          papers
          ripunzip
          zip
          tealdeer
          (mpv.override {
            scripts = [
              mpvScripts.thumbfast
            ];
          })
        ];
      };
  };
}
