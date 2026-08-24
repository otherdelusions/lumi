{
  den.aspects.netsec.clash-verge = {
    nixos = {
      programs.clash-verge = {
        enable = true;
        group = "wheel";
      };
    };
  };
}
