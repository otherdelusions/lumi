{ den, ... }:
{
  den.aspects.homelab.services = {
    includes = [ den.aspects.homelab ];

    nixos =
      { config, ... }:
      {
        systemd.tmpfiles.settings.homelab-services."${config.homelab.dirs.data}/services".d = {
          mode = "0755";
          user = "root";
          group = "root";
        };
      };
  };
}
