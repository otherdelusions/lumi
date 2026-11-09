{ homelab, lib, ... }:
{
  users.groups.${homelab.group}.gid = 1500;
  users.users.${homelab.user} = {
    isSystemUser = true;
    uid = 1500;
    inherit (homelab) group;
  };

  systemd.tmpfiles.settings = {
    homelab-base."${homelab.dirs.data}".d = {
      mode = "0755";
      user = "root";
      group = "root";
    };
    homelab-services."${homelab.dirs.data}/services".d = {
      mode = "0755";
      user = "root";
      group = "root";
    };

    ash-homelab-base."${homelab.dirs.content}".z = {
      mode = "2775";
      user = "root";
      inherit (homelab) group;
    };
    ash-homelab-media."${homelab.dirs.content}"."a+".argument =
      "u::rwx,g::rwx,o::rx,d:u::rwx,d:g::rwx,d:o::rx";
  };

  systemd.tmpfiles.settings.media = lib.genAttrs homelab.dirs.extra (_: {
    d = {
      mode = "2775";
      inherit (homelab) user group;
    };
    "a+".argument = "u::rwx,g::rwx,o::rx,d:u::rwx,d:g::rwx,d:o::rx";
  });
}
