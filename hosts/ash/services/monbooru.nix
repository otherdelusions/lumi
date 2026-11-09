{
  homelab,
  config,
  self,
  pkgs,
  ...
}:
let
  port = 4903;
in
{
  imports = [ self.nixosModules.monbooru ];

  services.monbooru = {
    enable = true;
    package = self.packages.${pkgs.stdenv.hostPlatform.system}.monbooru;
    openFirewall = true;
    inherit (homelab) user group;
    timeZone = config.time.timeZone;
    dataDir = "${homelab.dirs.data}/services/monbooru";

    settings = {
      server = {
        bind_address = "${homelab.address}:${toString port}";
        base_url = "http://${homelab.baseDomain}:${toString port}";
      };

      galleries = [
        {
          name = "default";
          gallery_path = "${homelab.dirs.content}/galleries/default";
        }
        {
          name = "extra";
          gallery_path = "${homelab.dirs.content}/galleries/extra";
        }
      ];
    };
  };
}
