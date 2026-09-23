{ den, ... }:
{
  den.aspects.tiling-wm.includes = [ den.aspects.tiling-wm.audio ];

  den.aspects.tiling-wm.audio = {
    nixos =
      { lib, config, ... }:
      {
        security.rtkit.enable = lib.mkDefault config.services.pipewire.enable;

        services.pipewire = {
          enable = true;
          alsa.enable = true;
          pulse.enable = true;
        };
      };
  };
}
