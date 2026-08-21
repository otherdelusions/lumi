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
              ForwardAgent = lib.mkDefault true;
              Compression = false;
              AddKeysToAgent = "yes";
              ControlMaster = "no";
              ControlPersist = "no";
            };
          }
          // lib.mapAttrs (_: host: {
            HostName = lib.mkDefault "${host.hostName}.local"; # mdns name
            User = lib.mkDefault user.userName;
          }) sshHosts;
        };
      };
  };
}
