{ lib, ... }:
{
  imports = [
    ../../users/ferret.nix
    ../../modules/zfs.nix
    ./hardware.nix
    ./disko.nix
    ./storage.nix
    ./users.nix
    ./services
  ];

  networking.hostName = "ash";
  networking.interfaces.eno1.wakeOnLan.enable = true;
  documentation.man.cache.enable = false;

  boot.loader = {
    systemd-boot = {
      enable = true;
      configurationLimit = lib.mkDefault 5;
    };
    timeout = lib.mkDefault 3;
    efi.canTouchEfiVariables = true;
  };

  fonts.fontconfig.enable = lib.mkDefault false;
  xdg = {
    autostart.enable = lib.mkDefault false;
    icons.enable = lib.mkDefault false;
    menus.enable = lib.mkDefault false;
    mime.enable = lib.mkDefault false;
    sounds.enable = lib.mkDefault false;
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

  users.users.ferret.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGyfwM5xpexbGKqVwGGOUvsIUjafEAmkFR3mgyMNRoLe ferret@ember"
  ];

}
