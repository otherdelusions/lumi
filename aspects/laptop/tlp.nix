{ den, ... }:
{
  den.aspects.laptop.includes = [ den.aspects.laptop.tlp ];

  den.aspects.laptop.tlp = {
    nixos =
      { lib, config, ... }:
      {
        services.tlp = {
          enable = true;
          pd.enable = true;
        };

        services.power-profiles-daemon.enable = lib.mkForce (!config.services.tlp.enable);
      };
  };
}
