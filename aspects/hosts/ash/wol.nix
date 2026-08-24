{
  den.aspects.ash = {
    nixos = {
      networking.interfaces.eno1.wakeOnLan.enable = true;
      networking.firewall.allowedUDPPorts = [ 9 ];
    };
  };
}
