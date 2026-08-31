{ den, inputs, ... }:
{
  den.aspects.netsec.includes = [ den.aspects.netsec.zapret ];

  den.aspects.netsec.zapret = {
    nixos = {
      imports = [ inputs.self.nixosModules.zapret ];

      netsec.zapret = {
        enable = true;
        addHosts = true;
        strategy = "s2_any";
      };
    };
  };
}
