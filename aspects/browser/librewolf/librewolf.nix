{ config, ... }:
{
  den.aspects.browser.librewolf = {
    nixos = {
      imports = [ config.flake.nixosModules.librewolf ];

      programs.librewolf = {
        enable = true;
      };
    };

    homeManager.programs.librewolf.enable = true;
  };
}
