{ config, lib, ... }:
let
  cfg = config.services.suwayomi-server;
  mediaDirs = [
    cfg.settings.server.localSourcePath
    cfg.settings.server.downloadsPath
  ];
in
{
  services.suwayomi-server = {
    enable = true;
    openFirewall = true;
    user = "homelab";
    group = "homelab";
    dataDir = "/var/lib/homelab/services/suwayomi";
    settings.server = {
      port = 8080;
      systemTrayEnabled = false;
      initialOpenInBrowserEnabled = false;
      backupInterval = 0;
      globalUpdateInterval = 0;
      authMode = "NONE";
      opdsEnablePageReadProgress = false;
      downloadsPath = "/mirror/manga/downloads";
      localSourcePath = "/mirror/manga/local";
    };
  };
  systemd = {
    tmpfiles.settings = {
      suwayomi-dirs =
        lib.genAttrs
          (
            [
              cfg.dataDir
              "${cfg.dataDir}/.local"
              "${cfg.dataDir}/.local/share"
            ]
            ++ mediaDirs
          )
          (_: {
            d = {
              mode = "2775";
              inherit (cfg) user group;
            };
          });
      suwayomi-media = lib.genAttrs mediaDirs (_: {
        "a+".argument = "u::rwx,g::rwx,o::rx,d:u::rwx,d:g::rwx,d:o::rx";
      });
    };
    services.suwayomi-server = {
      unitConfig.RequiresMountsFor = [ cfg.dataDir ] ++ mediaDirs;
      environment = {
        HOME = cfg.dataDir;
        JAVA_TOOL_OPTIONS = "-Duser.home=${cfg.dataDir}";
      };
      serviceConfig.ReadWritePaths = [ cfg.dataDir ] ++ mediaDirs;
    };
  };
}
