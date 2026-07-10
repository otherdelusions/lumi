{ den, ... }:
{
  den.aspects.theming.stylix.includes = [ den.aspects.theming.stylix.foot ];

  den.aspects.theming.stylix.foot = {
    homeManager =
      { config, lib, ... }:
      let
        inherit (config.lib.stylix) colors;
      in
      {
        programs.foot.settings."colors-dark".cursor = lib.mkForce "${colors.base00} ${colors.base07}";
      };
  };
}
