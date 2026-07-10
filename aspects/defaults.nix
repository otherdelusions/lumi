{ den, ... }:
{
  den.default = { lib, ... }: {
    includes = [
      den.batteries.hostname
      den.batteries.inputs'
      den.batteries.self'
    ];

    nixos.system.stateVersion = "26.05";
    homeManager.home.stateVersion = "26.05";
    user.initialPassword = lib.mkDefault "changeme";
  };

  den.schema.hm-host.includes = [
    {
      name = "hm-settings";
      nixos.home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;
        backupFileExtension = "hm-backup";
      };
    }
  ];
}
