{ den, ... }:
{
  den.aspects.tiling-wm.includes = [ den.aspects.tiling-wm.dux-greeter ];

  den.aspects.tiling-wm.dux-greeter = {
    nixos = {
      services.displayManager.dux-greeter = {
        enable = true;
      };
    };
  };
}
