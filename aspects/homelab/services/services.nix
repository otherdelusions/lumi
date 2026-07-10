{ den, ... }:
{
  den.aspects.homelab.services = {
    includes = [ den.aspects.homelab ];

    nixos =
      { config, ... }:
      {
        homelab.dirs.extra = [ "${config.homelab.dirs.data}/services" ];
      };
  };
}
