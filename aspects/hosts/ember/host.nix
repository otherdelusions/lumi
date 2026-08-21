{ den, ... }:
{
  den.aspects.ember = {
    includes =
      with den.aspects;
      [
        dev
        graphical
        tiling-wm
        laptop
        netsec
        theming
      ]
      ++ [
        browser.librewolf
        netsec.flclash
      ];

    nixos = {
      time.timeZone = "Europe/Moscow";
      networking.networkmanager.enable = true;
      nixpkgs.config.allowUnfree = true;

      documentation.man.cache.enable = false;

      services.avahi = {
        enable = true;
        nssmdns4 = true;
      };
    };
  };
}
