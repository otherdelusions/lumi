{ den, ... }:
{
  den.aspects.ember = {
    includes =
      with den.aspects;
      [
        tiling-wm
        laptop
        netsec
        theming
      ]
      ++ [
        browser.librewolf
        netsec.clash-verge
      ];

    nixos = { config, pkgs, ... }: {
      networking.networkmanager.enable = true;

      services.avahi = {
        enable = true;
        nssmdns4 = true;
      };

      services.displayManager.dms-greeter.configHome = config.users.users.ferret.home;

      time.timeZone = "Europe/Moscow";
      documentation.man.cache.enable = false;
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
        bubblewrap
        mcp-nixos
      ];
    };
  };
}
