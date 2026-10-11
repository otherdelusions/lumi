{ den, ... }:
{
  den.aspects.ferret.includes = [
    (den.lib.policy.when ({ host, ... }: host.hasAspect den.aspects.theming) {
      homeManager = { inputs', ... }: {
        theme =
          let
            apple-fonts = inputs'.apple-fonts.packages;
          in
          {
            wallPaper = "${../../../config/wallpaper}/qingyi.jpg";

            fonts = {
              monospace = {
                package = apple-fonts.sf-mono-nerd;
                name = "SFMono Nerd Font";
              };
              sansSerif = {
                package = apple-fonts.sf-pro-nerd;
                name = "SFProDisplay Nerd Font";
              };
              serif = {
                package = apple-fonts.ny-nerd;
                name = "New York Nerd Font";
              };
            };

            profileNames = [ "ferret" ];
          };
      };
    })
  ];
}
