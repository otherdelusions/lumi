{ den, lib, ... }:
{
  den.aspects.dev.includes = [ den.aspects.dev.ssh-client ];

  den.aspects.dev.ssh-client = {
    homeManager =
      { user, ... }:
      let
        sshHosts = lib.concatMapAttrs (_: lib.filterAttrs (_: host: host.users ? ${user.name})) den.hosts;
      in
      {
        programs.ssh = {
          enable = lib.mkDefault true;
          enableDefaultConfig = false;

          settings = {
            "*" = {
              ForwardAgent = false;
              Compression = false;
              AddKeysToAgent = "yes";
              ControlMaster = "no";
              ControlPersist = "no";
            };
          }
          // lib.mapAttrs (_: host: {
            HostName = host.hostName;
            User = user.userName;
          }) sshHosts;
        };
      };
  };
}
