{ homelab, config, ... }:
{
  services.samba = {
    enable = true;
    openFirewall = true;

    settings = {
      global = {
        workgroup = "WORKGROUP";
        "server string" = config.networking.hostName;
        "netbios name" = config.networking.hostName;
        security = "user";
        "invalid users" = [ "root" ];
        "guest account" = "nobody";
        "map to guest" = "bad user";
        "passdb backend" = "tdbsam";
      };

      media = {
        path = homelab.dirs.content;
        browseable = "yes";
        "read only" = "no";
        "guest ok" = "no";
        "inherit permissions" = "yes";
      };
    };
  };

  services.samba-wsdd = {
    enable = true;
    discovery = true;
    openFirewall = true;
  };
}
