{ config, ... }:
{
  imports = [
    ./users.nix
    ./home.nix
    ./hardware.nix
    ./disko.nix
    ./services
  ];

  _module.args.homelab = {
    baseDomain = "${config.networking.hostName}.local";
    address = "0.0.0.0";
    user = "homelab";
    group = "homelab";
    dirs = {
      content = "/mirror";
      data = "/var/lib/homelab";
      extra = [
        "/mirror/galleries"
        "/mirror/galleries/default"
        "/mirror/galleries/extra"
        "/mirror/music"
        "/mirror/manga"
        "/mirror/manga/local"
        "/mirror/manga/downloads"
      ];
    };
  };

  security.nix-secrets = {
    identityPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
    recipientAliases.ash = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGpEpH0wV2JehS/7fDYFKWZfkFeLcQ/opZAtLoVxfQrH root@ash";
  };

  networking.interfaces.eno1.wakeOnLan.enable = true;
  documentation.man.cache.enable = false;
  services.zfs.autoScrub.enable = true;
  fonts.fontconfig.enable = false;

  xdg = {
    autostart.enable = false;
    icons.enable = false;
    menus.enable = false;
    mime.enable = false;
    sounds.enable = false;
  };

  services.openssh = {
    enable = true;
    openFirewall = true;

    settings = {
      X11Forwarding = false;
      UseDns = false;
      StreamLocalBindUnlink = true;
      PermitRootLogin = "prohibit-password";
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
    };
  };
}
