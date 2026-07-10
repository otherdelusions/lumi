{ den, ... }:
{
  den.aspects.homelab.containers = {
    includes = [ den.aspects.homelab ];

    nixos =
      { pkgs, config, ... }:
      {
        homelab.dirs.extra = [ "${config.homelab.dirs.data}/containers" ];

        virtualisation = {
          containers.enable = true;
          oci-containers.backend = "podman";

          podman = {
            enable = true;
            dockerCompat = true;
            defaultNetwork.settings.dns_enabled = true;
          };
        };

        environment.systemPackages = with pkgs; [
          podman-compose
          podman-tui
        ];
      };
  };
}
