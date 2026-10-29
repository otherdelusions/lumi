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

    provides.ferret.nixos = { config, user, ... }: {
      services.displayManager.dux-greeter.configHome = config.users.users.${user.userName}.home;
    };

    nixos = { pkgs, ... }: {
      networking = {
        networkmanager.enable = true;
        enableIPv6 = false;
        firewall.allowedUDPPorts = [ 5353 ]; # mdns reply
      };

      systemd.services.NetworkManager-wait-online.enable = false;
      boot.kernel.sysctl."net.ipv4.tcp_fastopen" = 0; # else DoT wont work

      # mdns resolve
      services.resolved = {
        enable = true;
        settings.Resolve.MulticastDNS = "resolve";
      };

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
