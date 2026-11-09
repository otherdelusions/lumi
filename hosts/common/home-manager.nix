{
  inputs,
  self,
  lib,
  ...
}:
{
  imports = [ inputs.home-manager.nixosModules.home-manager ];

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "hm-backup";
    extraSpecialArgs = { inherit inputs self; };
    sharedModules = [
      {
        programs.home-manager.enable = true;
        home.stateVersion = lib.mkDefault "26.05";
      }
    ];
  };
}
