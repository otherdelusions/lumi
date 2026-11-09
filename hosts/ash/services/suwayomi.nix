{
  homelab,
  config,
  lib,
  ...
}:
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
    inherit (homelab) user group;
    dataDir = "${homelab.dirs.data}/services/suwayomi";

    settings.server = {
      port = 8080;
      systemTrayEnabled = false;
      initialOpenInBrowserEnabled = false;
      backupInterval = 0;
      globalUpdateInterval = 0;
      authMode = "NONE";
      opdsEnablePageReadProgress = false;
      downloadsPath = "${homelab.dirs.content}/manga/downloads";
      localSourcePath = "${homelab.dirs.content}/manga/local";
    };
  };

  systemd = {
    tmpfiles.settings = {
      suwayomi-dirs =
        lib.genAttrs
          [
            cfg.dataDir
            "${cfg.dataDir}/.local"
            "${cfg.dataDir}/.local/share"
          ]
          (_: {
            d = {
              mode = "2775";
              inherit (cfg) user group;
            };
          });
    };

    services.suwayomi-server = {
      unitConfig.RequiresMountsFor = [ cfg.dataDir ] ++ mediaDirs;
      serviceConfig.ReadWritePaths = [ cfg.dataDir ] ++ mediaDirs;

      environment = {
        HOME = cfg.dataDir;
        JAVA_TOOL_OPTIONS = "-Duser.home=${cfg.dataDir}";
      };
    };
  };
}
