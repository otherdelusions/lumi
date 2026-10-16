{
  den.aspects.netsec.clash-verge = {
    nixos = {
      programs.clash-verge = {
        enable = true;
        tunMode = true;
        serviceMode = true;
        group = "wheel";
      };

      networking.firewall.trustedInterfaces = [ "Meta" ];

      # Remember to set "Auto Redirect" in TUN settings
      # if you want internet
    };
  };
}
