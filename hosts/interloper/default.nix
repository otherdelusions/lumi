{
  inputs,
  modulesPath,
  pkgs,
  ...
}:
{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    (modulesPath + "/installer/cd-dvd/installation-cd-minimal.nix")
  ];

  system.stateVersion = "26.05";

  networking.hostId = "8425e349";

  boot.zfs = {
    package = pkgs.zfs_unstable;
    forceImportRoot = false;
  };

  networking.firewall.enable = false;
  systemd.services.NetworkManager-wait-online.enable = false;

  environment.loginShellInit = ''
    echo -e "I'm receiving much stronger energy readings now that we're beneath the crust.\n"

    if [ -z "$SSH_CONNECTION" ]; then
      echo -n "ssh here using 'ssh nixos@interloper.local'"
      ip=$(hostname -I | cut -d' ' -f1)
      [ -n "$ip" ] && echo -n " (or using nixos@$ip)"
      echo
    fi
  '';

  services = {
    avahi = {
      enable = true;
      settings.publish = {
        disable-publishing = false;
        publish-addresses = true;
      };
    };

    openssh = {
      enable = true;
      settings = {
        PermitRootLogin = "yes";
        PermitEmptyPasswords = "yes";
      };
    };
  };

  security.pam.services.sshd.allowNullPassword = true;

  environment.systemPackages = with pkgs; [
    git
    helix
    nurl
    nixd
    wget
    curl
    smartmontools
    unzip
    zip
    nixfmt
    inputs.disko.packages.${pkgs.stdenv.hostPlatform.system}.disko
  ];
}
