{
  den.aspects.tiling-wm = {
    nixos =
      { host, ... }:
      {
        assertions = [
          {
            assertion = host.desktop.compositor != null;
            message = "tiling-wm aspect requires host.desktop.compositor to be set";
          }
        ];
      };
  };
}
