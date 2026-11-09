{ config, lib, ... }:
{
  networking.networkmanager.wifi = {
    backend = "iwd";
    powersave = true;
  };

  services = {
    tlp = {
      enable = true;
      pd.enable = true;
    };

    power-profiles-daemon.enable = lib.mkForce (!config.services.tlp.enable);
    upower.enable = true;
  };
}
