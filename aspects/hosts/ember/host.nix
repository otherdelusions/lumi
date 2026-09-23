{ den, ... }:
{
  den.aspects.ember = {
    includes =
      with den.aspects;
      [
        dev
        tiling-wm
        laptop
        netsec
        theming
      ]
      ++ [
        browser.librewolf
        netsec.clash-verge
      ];

    nixos = { pkgs, ... }: {
      time.timeZone = "Europe/Moscow";
      networking.networkmanager.enable = true;
      nixpkgs.config.allowUnfree = true;

      documentation.man.cache.enable = false;

      services.avahi = {
        enable = true;
        nssmdns4 = true;
      };

      environment.systemPackages = with pkgs; [
        loupe
        papers
        unzip
        zip
        (mpv.override {
          scripts = with mpvScripts; [
            thumbfast
          ];
        })
      ];
    };
  };
}
