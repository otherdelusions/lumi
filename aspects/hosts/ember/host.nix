{ den, ... }:
{
  den.aspects.ember = {
    includes =
      with den.aspects;
      [
        common
        dev
        graphical
        tiling-wm
        laptop
        netsec
        theming
      ]
      ++ [
        dev.ai
        browser.librewolf
        netsec.flclash
      ];

    nixos = {
      time.timeZone = "Europe/Moscow";
      networking.networkmanager.enable = true;
      nixpkgs.config.allowUnfree = true;

      systemd.user.services.niri-flake-polkit.enable = false;

      documentation.man.cache.enable = false;
    };
  };
}
