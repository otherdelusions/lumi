{ den, ... }:
{
  den.aspects.graphical.includes = [ den.aspects.graphical.pipewire ];

  den.aspects.graphical.pipewire = {
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
