{
  inputs,
  modulesPath,
  pkgs,
  ...
}:
{
  imports = [
    ../../modules/zfs.nix
    (modulesPath + "/installer/scan/not-detected.nix")
    (modulesPath + "/installer/cd-dvd/installation-cd-minimal.nix")
  ];
  networking.hostName = "interloper";
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
    zfs.autoScrub.enable = false;
    avahi = {
      enable = true;
      publish = {
        enable = true;
        addresses = true;
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
  environment.systemPackages = [
    inputs.disko.packages.${pkgs.stdenv.hostPlatform.system}.disko
  ]
  ++ (with pkgs; [
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
  ]);
}
