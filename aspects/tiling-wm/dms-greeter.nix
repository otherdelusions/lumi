{ den, ... }:
{
  den.aspects.tiling-wm.includes = [ den.aspects.tiling-wm.dms-greeter ];

  den.aspects.tiling-wm.dms-greeter = {
    nixos = { lib, ... }: {
      services.displayManager.dms-greeter = {
        enable = true;
        logs.save = lib.mkDefault true;
      };
    };
  };
}
