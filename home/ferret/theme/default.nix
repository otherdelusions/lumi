{ inputs, pkgs, ... }: {
  imports = [
    ./options.nix
    ./fonts.nix
    ./gtk.nix
    ./dms-shell.nix
    ./librewolf.nix
    ./helix.nix
    ./foot.nix
    ./niri.nix
  ];

  theme =
    let
      apple-fonts = inputs.apple-fonts.packages.${pkgs.stdenv.hostPlatform.system};
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

      browser.librewolf.profileNames = [ "ferret" ];
    };
}
