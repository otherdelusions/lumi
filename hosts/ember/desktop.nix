{
  config,
  lib,
  pkgs,
  ...
}:
{
  desktop.terminal = "foot";
  boot.loader = {
    grub = {
      enable = true;
      efiSupport = true;
      configurationLimit = lib.mkDefault 5;
      device = "nodev";
      timeoutStyle = lib.mkDefault "hidden";
    };
    timeout = lib.mkDefault 0;
    efi.canTouchEfiVariables = true;
  };

  programs = {
    niri.enable = true;
    dms-shell.enable = true;
    nautilus-open-any-terminal = {
      enable = true;
      terminal = config.desktop.terminal;
    };
  };
  services = {
    displayManager.dms-greeter = {
      enable = true;
      compositor.name = "niri";
      logs.save = lib.mkDefault true;
      configHome = config.users.users.ferret.home;
    };
    gnome.gcr-ssh-agent.enable = false;
    pipewire = {
      enable = true;
      alsa.enable = true;
      pulse.enable = true;
    };
    gvfs.enable = true;
  };
  security.rtkit.enable = lib.mkDefault config.services.pipewire.enable;

  fonts.enableDefaultPackages = true;
  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk-sans
  ];
  environment.systemPackages = with pkgs; [
    nautilus
    ffmpegthumbnailer
    wl-clipboard
  ];
}
