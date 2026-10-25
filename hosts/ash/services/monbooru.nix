{ config, inputs, ... }:
let
  cfg = config.services.monbooru;
  port = 8455;
in
{
  imports = [ ../../../modules/monbooru.nix ];
  nixpkgs.overlays = [
    (_final: prev: { monbooru = inputs.self.packages.${prev.stdenv.hostPlatform.system}.monbooru; })
  ];
  services.monbooru = {
    enable = true;
    openFirewall = true;
    user = "homelab";
    group = "homelab";
    timeZone = config.time.timeZone;
    dataDir = "/var/lib/homelab/services/monbooru";
    settings = {
      server = {
        bind_address = "0.0.0.0:${toString port}";
        base_url = "http://${config.networking.hostName}.local:${toString port}";
      };
      galleries = [
        {
          name = "images";
          gallery_path = "/mirror/images";
        }
      ];
    };
  };
  systemd.tmpfiles.settings.monbooru-media = builtins.listToAttrs (
    map (gallery: {
      name = gallery.gallery_path;
      value = {
        d = {
          mode = "2775";
          inherit (cfg) user group;
        };
        "a+".argument = "u::rwx,g::rwx,o::rx,d:u::rwx,d:g::rwx,d:o::rx";
      };
    }) cfg.settings.galleries
  );
}
