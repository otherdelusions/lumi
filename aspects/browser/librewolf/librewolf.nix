{ config, ... }:
{
  den.aspects.browser.librewolf = {
    nixos = {
      imports = [ config.flake.nixosModules.librewolf ];

      programs.librewolf = {
        enable = true;
      };
    };

    provides.to-users.homeManager.programs.librewolf.enable = true;
  };
}
