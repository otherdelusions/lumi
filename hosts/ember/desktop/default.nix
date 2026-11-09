{
  config,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    ./dux-shell.nix
    ./librewolf
  ];

  programs = {
    niri.enable = true;
    nautilus-open-any-terminal = {
      enable = true;
      terminal = "foot";
    };
  };

  services = {
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
