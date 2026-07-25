{ den, ... }:
{
  den.aspects.interloper = {
    includes = with den.aspects; [
      server.zfs
    ];

    nixos = {
      networking.firewall.enable = false;

      services.zfs.autoScrub.enable = false;

      environment.loginShellInit = ''
        echo -e "I'm receiving much stronger energy readings now that we're beneath the crust.\n"

        if [ -z "$SSH_CONNECTION" ]; then
          echo -n "ssh here using 'ssh nixos@interloper.local'"
          ip=$(hostname -I | cut -d' ' -f1)
          [ -n "$ip" ] && echo -n " (or using nixos@$ip)"
          echo
        fi
      '';

      services.avahi = {
        enable = true;
        publish = {
          enable = true;
          addresses = true;
        };
      };
    };
  };
}
