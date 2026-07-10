{ den, ... }:
{
  den.aspects.theming.stylix.includes = [ den.aspects.theming.stylix.niri ];

  den.aspects.theming.stylix.niri = {
    homeManager =
      {
        config,
        lib,
        osConfig,
        ...
      }:
      lib.mkIf (osConfig.programs ? niri && osConfig.programs.niri.enable) {
        programs.niri.settings =
          let
            inherit (config.lib.stylix) colors;
          in
          {
            layout.background-color = lib.mkForce colors.withHashtag.base00;
            overview.backdrop-color = lib.mkForce colors.withHashtag.base00;
          };
      };
  };
}
