{
  users.groups.homelab.gid = 1500;
  users.users.homelab = {
    isSystemUser = true;
    uid = 1500;
    group = "homelab";
  };

  systemd.tmpfiles.settings = {
    homelab-base."/var/lib/homelab".d = {
      mode = "0755";
      user = "root";
      group = "root";
    };
    homelab-services."/var/lib/homelab/services".d = {
      mode = "0755";
      user = "root";
      group = "root";
    };
    ash-homelab-base."/mirror".z = {
      mode = "2775";
      user = "root";
      group = "homelab";
    };
    ash-homelab-media."/mirror"."a+".argument = "u::rwx,g::rwx,o::rx,d:u::rwx,d:g::rwx,d:o::rx";
  };
}
